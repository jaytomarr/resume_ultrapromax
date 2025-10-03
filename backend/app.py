from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import subprocess
import tempfile
import os
import shutil
import logging

# LaTeX will be available via system PATH on Render (Linux)
# No need to add Windows-specific MiKTeX paths

app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def escape_latex(text):
    """Escape special LaTeX characters to prevent compilation errors"""
    if not text:
        return ""
    
    # Convert to string and handle None values
    result = str(text)
    
    # Special LaTeX characters that break compilation
    replacements = {
        '\\': r'\textbackslash{}',  # Backslash - must be first!
        '&': r'\&',                 # Ampersand (table separator)
        '%': r'\%',                 # Percent (comment character)
        '$': r'\$',                 # Dollar (math mode)
        '#': r'\#',                 # Hash (macro parameter)
        '_': r'\_',                 # Underscore (subscript)
        '{': r'\{',                 # Left brace (grouping)
        '}': r'\}',                 # Right brace (grouping)
        '~': r'\textasciitilde{}',  # Tilde (non-breaking space)
        '^': r'\textasciicircum{}', # Caret (superscript)
    }
    
    # Apply replacements in order (backslash first to avoid double-escaping)
    for old, new in replacements.items():
        result = result.replace(old, new)
    
    return result

def generate_latex(data):
    """Generate LaTeX from JSON data"""
    
    # Read template
    with open('resume_template.tex', 'r') as f:
        template = f.read()
    
    # Replace profile section
    profile = data.get('profile', {})
    template = template.replace('{{NAME}}', escape_latex(profile.get('name', '')))
    template = template.replace('{{PHONE}}', escape_latex(profile.get('phone', '')))
    template = template.replace('{{EMAIL}}', escape_latex(profile.get('email', '')))
    template = template.replace('{{LINKEDIN}}', escape_latex(profile.get('linkedin', '')))
    template = template.replace('{{GITHUB}}', escape_latex(profile.get('github', '')))
    template = template.replace('{{WEBSITE}}', escape_latex(profile.get('website', '')))
    template = template.replace('{{SUMMARY}}', escape_latex(profile.get('summary', '')))
    
    # Replace skills
    skills = data.get('skills', {})
    template = template.replace('{{LANGUAGES}}', escape_latex(skills.get('languages', '')))
    template = template.replace('{{TECHNOLOGIES}}', escape_latex(skills.get('technologies', '')))
    template = template.replace('{{PROFESSIONAL}}', escape_latex(skills.get('professional', '')))
    
    # Generate Education section
    education_tex = ""
    for edu in data.get('education', []):
        education_tex += f"""    \\resumeSubheading
      {{{escape_latex(edu.get('university', ''))}}}{{{escape_latex(edu.get('date', ''))}}}
      {{{escape_latex(edu.get('degree', ''))}}}{{{escape_latex(edu.get('cgpa', ''))}}}
"""
    if not education_tex.strip():
        education_tex = "    \\resumeSubheading{No Education Listed}{}{}{}"
    template = template.replace('{{EDUCATION}}', education_tex)
    
    # Generate Experience section
    experience_tex = ""
    experience_list = data.get('experience', [])
    for i, exp in enumerate(experience_list):
        location = f" $|$ \\emph{{{escape_latex(exp.get('location', ''))}}}" if exp.get('location') else ""
        experience_tex += f"""      \\resumeProjectHeading
        {{\\textbf{{{escape_latex(exp.get('company', ''))}}} $|$ \\emph{{{escape_latex(exp.get('role', ''))}}} {location}}}{{{escape_latex(exp.get('date', ''))}}}
        \\vspace{{-8pt}}
        \\resumeItemListStart
"""
        for point in exp.get('points', []):
            experience_tex += f"            \\resumeItem{{{escape_latex(point)}}}\n"
        experience_tex += "        \\resumeItemListEnd\n"
        
        # Spacing logic: Only add vspace{-8pt} if this is NOT the last item
        # This prevents inconsistent spacing where the last item would have 0pt spacing
        if i < len(experience_list) - 1:
            experience_tex += "        \\vspace{-8pt}\n"
        else:
            experience_tex += "        % Last experience item - no vspace to maintain consistent spacing\n"
            experience_tex += "        \\vspace{0pt}\n"
    
    if not experience_tex.strip():
        experience_tex = """      \\resumeProjectHeading
        {\\textbf{No Experience Listed}}{}
        \\vspace{-8pt}
        \\resumeItemListStart
            \\resumeItem{No work experience to display}
        \\resumeItemListEnd
        \\vspace{0pt}
"""
    template = template.replace('{{EXPERIENCE}}', experience_tex)
    
    # Generate Projects section
    projects_tex = ""
    projects_list = data.get('projects', [])
    for i, proj in enumerate(projects_list):
        link = f"{{\\href{{{escape_latex(proj.get('link', ''))}}}{{\\it Github}}}}" if proj.get('link') else ""
        projects_tex += f"""        \\resumeProjectHeading
          {{\\textbf{{{escape_latex(proj.get('name', ''))}}}}}
          {link}
          \\vspace{{-8pt}}
          \\resumeItemListStart
"""
        for point in proj.get('points', []):
            projects_tex += f"            \\resumeItem{{{escape_latex(point)}}}\n"
        projects_tex += "          \\resumeItemListEnd\n"
        
        # Spacing logic: Only add vspace{-8pt} if this is NOT the last item
        # This prevents inconsistent spacing where the last item would have 0pt spacing
        if i < len(projects_list) - 1:
            projects_tex += "          \\vspace{-8pt}\n"
        else:
            projects_tex += "          % Last project item - no vspace to maintain consistent spacing\n"
            projects_tex += "          \\vspace{0pt}\n"
    
    if not projects_tex.strip():
        projects_tex = """        \\resumeProjectHeading
          {\\textbf{No Projects Listed}}{}
          \\vspace{-8pt}
          \\resumeItemListStart
              \\resumeItem{No projects to display}
          \\resumeItemListEnd
          \\vspace{0pt}
"""
    template = template.replace('{{PROJECTS}}', projects_tex)
    
    # Generate Leadership section
    leadership_tex = ""
    leadership_list = data.get('leadership', [])
    for i, lead in enumerate(leadership_list):
        leadership_tex += f"""        \\resumeProjectHeading
          {{\\textbf{{{escape_latex(lead.get('organization', ''))}}} $|$ \\emph{{{escape_latex(lead.get('role', ''))}}}}} {{{escape_latex(lead.get('date', ''))}}}
          \\vspace{{-8pt}}
          \\resumeItemListStart
"""
        for point in lead.get('points', []):
            leadership_tex += f"            \\resumeItem{{{escape_latex(point)}}}\n"
        leadership_tex += "          \\resumeItemListEnd\n"
        
        # Spacing logic: Only add vspace{-8pt} if this is NOT the last item
        # This prevents inconsistent spacing where the last item would have 0pt spacing
        if i < len(leadership_list) - 1:
            leadership_tex += "          \\vspace{-8pt}\n"
        else:
            leadership_tex += "          % Last leadership item - no vspace to maintain consistent spacing\n"
            leadership_tex += "          \\vspace{0pt}\n"
    
    if not leadership_tex.strip():
        leadership_tex = """        \\resumeProjectHeading
          {\\textbf{No Leadership Listed}}{}
          \\vspace{-8pt}
          \\resumeItemListStart
              \\resumeItem{No leadership experience to display}
          \\resumeItemListEnd
          \\vspace{0pt}
"""
    template = template.replace('{{LEADERSHIP}}', leadership_tex)
    
    # Generate Achievements section
    achievements_tex = ""
    for ach in data.get('achievements', []):
        achievements_tex += f"        \\resumeItem{{{escape_latex(ach)}}}\n"
    if not achievements_tex.strip():
        achievements_tex = "        \\resumeItem{No achievements to display}\n"
    template = template.replace('{{ACHIEVEMENTS}}', achievements_tex)
    
    return template

def compile_latex_to_pdf(latex_content, temp_dir):
    """Compile LaTeX content to PDF using MikTeX with enhanced error handling"""
    
    # Write LaTeX content to file
    tex_file = os.path.join(temp_dir, 'resume.tex')
    with open(tex_file, 'w', encoding='utf-8') as f:
        f.write(latex_content)
    
    # Try different LaTeX compilers in order of preference
    compilers = [
        ['pdflatex', '-interaction=nonstopmode', '-output-directory', temp_dir, tex_file],
        ['xelatex', '-interaction=nonstopmode', '-output-directory', temp_dir, tex_file],
        ['lualatex', '-interaction=nonstopmode', '-output-directory', temp_dir, tex_file]
    ]
    
    pdf_file = os.path.join(temp_dir, 'resume.pdf')
    
    for compiler_cmd in compilers:
        try:
            logger.info(f"Trying compiler: {compiler_cmd[0]}")
            
            # Run the compiler
            result = subprocess.run(
                compiler_cmd,
                capture_output=True,
                text=True,
                timeout=120,  # 2 minute timeout
                cwd=temp_dir
            )
            
            logger.info(f"Compiler {compiler_cmd[0]} return code: {result.returncode}")
            
            if result.returncode == 0 and os.path.exists(pdf_file):
                logger.info(f"Successfully compiled with {compiler_cmd[0]}")
                return pdf_file, None
            else:
                # Enhanced error reporting for special character issues
                error_msg = result.stderr or result.stdout or "Unknown error"
                
                # Check for common special character errors
                if "Undefined control sequence" in error_msg:
                    logger.error(f"LaTeX compilation failed due to undefined control sequence (likely special character issue)")
                    logger.error(f"Error details: {error_msg[:200]}...")
                    return None, f"LaTeX compilation failed: Special character error. Check for unescaped characters like &, %, $, #, _, {{, }}, ~, ^, or \\"
                elif "Missing" in error_msg and "item" in error_msg:
                    logger.error(f"LaTeX compilation failed due to missing item")
                    return None, f"LaTeX compilation failed: Template structure error"
                else:
                    logger.warning(f"Compiler {compiler_cmd[0]} failed:")
                    logger.warning(f"STDOUT: {result.stdout}")
                    logger.warning(f"STDERR: {result.stderr}")
                
        except subprocess.TimeoutExpired:
            logger.error(f"Compiler {compiler_cmd[0]} timed out")
            continue
        except FileNotFoundError:
            logger.warning(f"Compiler {compiler_cmd[0]} not found")
            continue
        except Exception as e:
            logger.error(f"Compiler {compiler_cmd[0]} failed with exception: {e}")
            continue
    
    return None, "All LaTeX compilers failed"

def check_latex_installation():
    """Check if LaTeX is properly installed"""
    try:
        # Try to run pdflatex --version
        result = subprocess.run(['pdflatex', '--version'], capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            logger.info("LaTeX pdflatex is available")
            return True
    except Exception as e:
        logger.warning(f"LaTeX check failed: {e}")
    
    return False

@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint"""
    latex_available = check_latex_installation()
    return jsonify({
        "status": "ok",
        "latex_available": latex_available,
        "message": "LaTeX is available" if latex_available else "LaTeX not found - PDF generation may fail"
    })

@app.route('/api/generate-resume', methods=['POST'])
def generate_resume():
    """Generate PDF resume from JSON data"""
    try:
        # Get JSON data
        data = request.get_json()
        if not data:
            return jsonify({"error": "No JSON data provided"}), 400
        
        logger.info("Generating resume PDF...")
        
        # Generate LaTeX content
        latex_content = generate_latex(data)
        logger.info(f"Generated LaTeX content ({len(latex_content)} characters)")
        
        # Create temporary directory for compilation
        with tempfile.TemporaryDirectory() as temp_dir:
            logger.info(f"Using temporary directory: {temp_dir}")
            
            # Compile LaTeX to PDF
            pdf_file, error = compile_latex_to_pdf(latex_content, temp_dir)
            
            if pdf_file and os.path.exists(pdf_file):
                # Read PDF content
                with open(pdf_file, 'rb') as f:
                    pdf_content = f.read()
                
                logger.info(f"Successfully generated PDF ({len(pdf_content)} bytes)")
                
                # Return PDF
                return Response(
                    pdf_content,
                    mimetype='application/pdf',
                    headers={
                        'Content-Disposition': 'inline; filename=resume.pdf',
                        'Content-Length': str(len(pdf_content))
                    }
                )
            else:
                logger.error(f"PDF generation failed: {error}")
                return jsonify({
                    "error": "PDF generation failed",
                    "details": error,
                    "message": "Unable to compile LaTeX to PDF. Please check your LaTeX installation."
                }), 500
                
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/api/preview-latex', methods=['POST'])
def preview_latex():
    """Preview LaTeX content without compilation"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No JSON data provided"}), 400
            
        latex_code = generate_latex(data)
        return Response(latex_code, mimetype='text/plain')
    except Exception as e:
        logger.error(f"LaTeX preview error: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Check LaTeX installation on startup
    if check_latex_installation():
        logger.info("LaTeX is available - PDF generation ready")
    else:
        logger.warning("LaTeX not found - PDF generation will fail")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
# Resume Generator Backend - Simple PRD

## Overview
A simple Flask backend that takes resume JSON data, generates a LaTeX document, and returns a PDF using LaTeX.Online API.

**That's it. Keep it simple.**

---

## Project Structure
```
resume-backend/
├── app.py                    # Main Flask app (everything in one file)
├── resume_template.tex       # LaTeX template with placeholders
├── requirements.txt          # Dependencies
└── test_data.json           # Sample data for testing
```

---

## Dependencies (requirements.txt)
```
Flask==3.0.0
Flask-CORS==4.0.0
requests==2.31.0
```

---

## Step 1: Create app.py

```python
from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import requests
import urllib.parse

app = Flask(__name__)
CORS(app)

def escape_latex(text):
    """Escape special LaTeX characters"""
    if not text:
        return ""
    
    replacements = {
        '\\': r'\textbackslash{}',
        '&': r'\&',
        '%': r'\%',
        '$': r'\$',
        '#': r'\#',
        '_': r'\_',
        '{': r'\{',
        '}': r'\}',
        '~': r'\textasciitilde{}',
        '^': r'\textasciicircum{}',
    }
    
    result = str(text)
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
      {{{escape_latex(edu.get('degree', ''))}}}{{{escape_latex(edu.get('gpa', ''))}}}
"""
    template = template.replace('{{EDUCATION}}', education_tex)
    
    # Generate Experience section
    experience_tex = ""
    for exp in data.get('experience', []):
        location = f" $|$ \\emph{{{escape_latex(exp.get('location', ''))}}}" if exp.get('location') else ""
        experience_tex += f"""      \\resumeProjectHeading
        {{\\textbf{{{escape_latex(exp.get('company', ''))}}} $|$ \\emph{{{escape_latex(exp.get('role', ''))}}} {location}}}{{{escape_latex(exp.get('date', ''))}}}
        \\vspace{{-8pt}}
        \\resumeItemListStart
"""
        for point in exp.get('points', []):
            experience_tex += f"            \\resumeItem{{{escape_latex(point)}}}\n"
        experience_tex += "        \\resumeItemListEnd\n        \\vspace{-8pt}\n"
    template = template.replace('{{EXPERIENCE}}', experience_tex)
    
    # Generate Projects section
    projects_tex = ""
    for proj in data.get('projects', []):
        link = f"{{\\href{{{escape_latex(proj.get('link', ''))}}}{{\\it Github}}}}" if proj.get('link') else ""
        projects_tex += f"""        \\resumeProjectHeading
          {{\\textbf{{{escape_latex(proj.get('name', ''))}}}}}
          {link}
          \\vspace{{-8pt}}
          \\resumeItemListStart
"""
        for point in proj.get('points', []):
            projects_tex += f"            \\resumeItem{{{escape_latex(point)}}}\n"
        projects_tex += "          \\resumeItemListEnd\n          \\vspace{-8pt}\n"
    template = template.replace('{{PROJECTS}}', projects_tex)
    
    # Generate Leadership section
    leadership_tex = ""
    for lead in data.get('leadership', []):
        leadership_tex += f"""        \\resumeProjectHeading
          {{\\textbf{{{escape_latex(lead.get('organization', ''))}}} $|$ \\emph{{{escape_latex(lead.get('role', ''))}}}}} {{{escape_latex(lead.get('date', ''))}}}
          \\vspace{{-8pt}}
          \\resumeItemListStart
"""
        for point in lead.get('points', []):
            leadership_tex += f"            \\resumeItem{{{escape_latex(point)}}}\n"
        leadership_tex += "          \\resumeItemListEnd\n"
    template = template.replace('{{LEADERSHIP}}', leadership_tex)
    
    # Generate Achievements section
    achievements_tex = ""
    for ach in data.get('achievements', []):
        achievements_tex += f"            \\resumeItem{{{escape_latex(ach)}}}\n"
    template = template.replace('{{ACHIEVEMENTS}}', achievements_tex)
    
    return template

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

@app.route('/api/generate-resume', methods=['POST'])
def generate_resume():
    try:
        # Get JSON data
        data = request.get_json()
        
        # Generate LaTeX
        latex_code = generate_latex(data)
        
        # URL encode
        encoded = urllib.parse.quote(latex_code)
        
        # Call LaTeX.Online API
        api_url = f"https://latexonline.cc/compile?text={encoded}"
        response = requests.get(api_url, timeout=60)
        
        if response.status_code == 200:
            # Return PDF
            return Response(
                response.content,
                mimetype='application/pdf',
                headers={'Content-Disposition': 'inline; filename=resume.pdf'}
            )
        else:
            # Return error
            return jsonify({
                "error": "Compilation failed",
                "details": response.text
            }), 500
            
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/preview-latex', methods=['POST'])
def preview_latex():
    try:
        data = request.get_json()
        latex_code = generate_latex(data)
        return Response(latex_code, mimetype='text/plain')
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
```

---

## Step 2: Create resume_template.tex

```latex
\documentclass[a4paper,10pt]{article}

\usepackage{latexsym}
\usepackage[empty]{fullpage}
\usepackage{titlesec}
\usepackage{marvosym}
\usepackage[usenames,dvipsnames]{color}
\usepackage{verbatim}
\usepackage{enumitem}
\usepackage[hidelinks]{hyperref}
\usepackage{fancyhdr}
\usepackage[english]{babel}
\usepackage{tabularx}
\usepackage{fontawesome5}
\usepackage{multicol}
\setlength{\multicolsep}{-3.0pt}
\setlength{\columnsep}{-1pt}
\input{glyphtounicode}

\pagestyle{fancy}
\fancyhf{}
\fancyfoot{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\addtolength{\oddsidemargin}{-0.6in}
\addtolength{\evensidemargin}{-0.5in}
\addtolength{\textwidth}{1.19in}
\addtolength{\topmargin}{-.7in}
\addtolength{\textheight}{1.4in}

\urlstyle{same}
\raggedbottom
\raggedright
\setlength{\tabcolsep}{0in}

\titleformat{\section}{
  \vspace{-4pt}\scshape\raggedright\large\bfseries
}{}{0em}{}[\color{black}\titlerule \vspace{-5pt}]

\pdfgentounicode=1

\newcommand{\resumeItem}[1]{\item\small{{#1 \vspace{-2pt}}}}
\newcommand{\resumeSubheading}[4]{
  \vspace{-2pt}\item
    \begin{tabular*}{1.0\textwidth}[t]{l@{\extracolsep{\fill}}r}
      \textbf{#1} & \textbf{\small #2} \\
      \textit{\small#3} & \textit{\small #4} \\
    \end{tabular*}\vspace{-7pt}
}
\newcommand{\resumeProjectHeading}[2]{
    \item
    \begin{tabular*}{1.001\textwidth}{l@{\extracolsep{\fill}}r}
      \small#1 & \textbf{\small #2}\\
    \end{tabular*}\vspace{-7pt}
}
\renewcommand\labelitemi{$\vcenter{\hbox{\tiny$\bullet$}}$}
\renewcommand\labelitemii{$\vcenter{\hbox{\tiny$\bullet$}}$}
\newcommand{\resumeSubHeadingListStart}{\begin{itemize}[leftmargin=0.0in, label={}]}
\newcommand{\resumeSubHeadingListEnd}{\end{itemize}}
\newcommand{\resumeItemListStart}{\begin{itemize}}
\newcommand{\resumeItemListEnd}{\end{itemize}\vspace{-5pt}}

\begin{document}

%-----HEADING-----
\begin{center}
    {\Huge \scshape {{NAME}}} \\ \vspace{5pt}
    \small \raisebox{-0.1\height}\faPhone\ {{PHONE}} ~
    \small \raisebox{-0.1\height}\faEnvelope\ {{EMAIL}} ~
    \href{https://{{LINKEDIN}}}{\raisebox{-0.2\height}\faLinkedin\ \underline{{{LINKEDIN}}}} ~
    \href{https://{{GITHUB}}}{\raisebox{-0.2\height}\faGithub\ \underline{{{GITHUB}}}} ~
    \href{https://{{WEBSITE}}}{\raisebox{-0.2\height}\faGlobe\ \underline{{{WEBSITE}}}}
    \vspace{-6pt}
\end{center}

%-----PROFILE-------
\section{Profile}
\small{{{SUMMARY}}}
\vspace{-6pt}

%------EDUCATION------
\section{Education}
  \resumeSubHeadingListStart
{{EDUCATION}}
  \resumeSubHeadingListEnd
  \vspace{-6pt}

%------EXPERIENCE------
\section{Experience}
  \vspace{-4pt}
    \resumeSubHeadingListStart
{{EXPERIENCE}}
    \resumeSubHeadingListEnd
\vspace{-8pt}

%------PROJECTS------
\section{Projects}
    \vspace{-4pt}
    \resumeSubHeadingListStart
{{PROJECTS}}
    \resumeSubHeadingListEnd
\vspace{-8pt}

%------SKILLS------
\section{Skills}
 \begin{itemize}[leftmargin=0.15in, label={}]
    \small{\item{
     \textbf{Languages}{: {{LANGUAGES}}} \\
     \textbf{Technologies \& Tools}{: {{TECHNOLOGIES}}} \\
     \textbf{Professional Skills}{: {{PROFESSIONAL}}} \\
    }}
 \end{itemize}
 \vspace{-12pt}

%------LEADERSHIP & ACTIVITIES------
\section{Leadership & Activities}
  \vspace{-4pt}
    \resumeSubHeadingListStart
{{LEADERSHIP}}
    \resumeSubHeadingListEnd
    \vspace{-8pt}

%------ACHIEVEMENTS & CERTIFICATIONS------
\section{Achievements & Certifications}
    \resumeSubHeadingListStart
        \resumeItemListStart
{{ACHIEVEMENTS}}
        \resumeItemListEnd
    \resumeSubHeadingListEnd

\end{document}
```

---

## Step 3: Create test_data.json

```json
{
  "profile": {
    "name": "John Doe",
    "phone": "+1 (123) 456-7890",
    "email": "john.doe@email.com",
    "linkedin": "linkedin.com/in/johndoe",
    "github": "github.com/johndoe",
    "website": "johndoe.dev",
    "summary": "A results-driven software developer with a passion for building robust and scalable applications."
  },
  "education": [
    {
      "university": "State University",
      "degree": "Bachelor of Science in Computer Science",
      "date": "2021 - 2025",
      "gpa": "GPA: 3.8/4.0"
    }
  ],
  "experience": [
    {
      "company": "Tech Solutions Inc.",
      "role": "Software Engineer Intern",
      "location": "San Francisco, CA",
      "date": "May 2024 - Aug 2024",
      "points": [
        "Developed and maintained key features for a customer-facing web application.",
        "Collaborated with a team of 5 engineers to design and implement a new API."
      ]
    }
  ],
  "projects": [
    {
      "name": "Project Alpha - Social Media App",
      "link": "https://github.com/johndoe/project-alpha",
      "points": [
        "Built a full-stack social media application.",
        "Implemented user authentication using Firebase."
      ]
    }
  ],
  "skills": {
    "languages": "Dart, Python, Java, JavaScript, SQL",
    "technologies": "Flutter, Firebase, Flask, REST APIs, Docker, Git",
    "professional": "Agile Methodologies, Problem Solving, Communication"
  },
  "leadership": [
    {
      "organization": "University Coding Club",
      "role": "President",
      "date": "Sep 2023 - May 2024",
      "points": [
        "Organized and led a university-wide hackathon.",
        "Mentored junior members and conducted workshops."
      ]
    }
  ],
  "achievements": [
    "Winner, University Hackathon 2024",
    "Dean's List (All Semesters)",
    "Certified Cloud Practitioner - AWS"
  ]
}
```

---

## How to Run

### Setup
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run server
python app.py
```

### Test
```bash
# Health check
curl http://localhost:5000/api/health

# Preview LaTeX
curl -X POST http://localhost:5000/api/preview-latex \
  -H "Content-Type: application/json" \
  -d @test_data.json

# Generate PDF
curl -X POST http://localhost:5000/api/generate-resume \
  -H "Content-Type: application/json" \
  -d @test_data.json \
  --output resume.pdf
```

---

## Cursor Prompt

Copy this into Cursor:

```
Create a simple Flask backend for resume generation. I have 3 files to create:

1. app.py - Main Flask application with:
   - escape_latex() function to escape special characters
   - generate_latex() function that does string replacement
   - Three routes: /api/health, /api/generate-resume, /api/preview-latex
   - Call LaTeX.Online API and return PDF

2. resume_template.tex - LaTeX template with placeholders like {{NAME}}, {{EMAIL}}, etc.

3. test_data.json - Sample resume data

Keep it simple - everything in one file (app.py), no complex validation, just make it work.
Use the code from the PRD exactly as written.
```

---

## That's It!

Three files. One simple app.py with basic string replacement. No fancy validation, no complex structure. Just works.

If Cursor has issues, just say: "Use the exact code from the PRD, don't modify it."
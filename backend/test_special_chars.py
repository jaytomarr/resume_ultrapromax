#!/usr/bin/env python3
"""
Test script for special character handling in resume generation
"""
import requests
import json

def test_special_characters():
    """Test resume generation with special characters"""
    
    # Test data with various special characters
    test_data = {
        "profile": {
            "name": "John Doe & Associates",
            "phone": "+1 (123) 456-7890",
            "email": "john_doe@company.com",
            "linkedin": "linkedin.com/in/john-doe",
            "github": "github.com/johndoe",
            "website": "johndoe.dev",
            "summary": "Building Flutter apps that work - 50% faster development with Firebase & REST APIs. Expert in C++/Python, working with ~100% success rate."
        },
        "education": [
            {
                "university": "Tech University & Research Center",
                "degree": "Bachelor of Science in Computer Science",
                "date": "2020 - 2024",
                "gpa": "GPA: 3.8/4.0"
            }
        ],
        "experience": [
            {
                "company": "Tech Corp & Partners",
                "role": "Software Engineer",
                "location": "San Francisco, CA",
                "date": "2023 - Present",
                "points": [
                    "Improved system performance by 75% using C++ optimization",
                    "Developed REST APIs with 99.9% uptime",
                    "Led team of 5+ developers in agile methodology",
                    "Implemented CI/CD pipeline reducing deployment time by 50%"
                ]
            }
        ],
        "projects": [
            {
                "name": "E-Commerce Platform",
                "link": "https://github.com/johndoe/ecommerce",
                "points": [
                    "Built full-stack application using React & Node.js",
                    "Integrated payment processing with 2.5% transaction fee",
                    "Achieved 95%+ test coverage using Jest & Mocha",
                    "Deployed on AWS with auto-scaling capabilities"
                ]
            }
        ],
        "skills": {
            "languages": "Python, C++, JavaScript, SQL",
            "technologies": "React, Node.js, AWS, Docker, Git, Linux",
            "professional": "Team Leadership, Project Management, Communication"
        },
        "leadership": [],
        "achievements": [
            "1st Place - Hackathon 2023",
            "Certified AWS Solutions Architect",
            "Published research paper in IEEE Journal"
        ]
    }
    
    try:
        print("Testing special character handling...")
        print("Special characters in test data:")
        print("- Ampersands: &")
        print("- Underscores: _")
        print("- Percentages: %")
        print("- Numbers with symbols: 50%, 75%, 99.9%")
        print("- URLs with special chars")
        print()
        
        # Test LaTeX preview first
        print("1. Testing LaTeX preview...")
        preview_response = requests.post(
            'http://localhost:5000/api/preview-latex',
            json=test_data,
            timeout=30
        )
        
        if preview_response.status_code == 200:
            print("✅ LaTeX preview successful")
            latex_content = preview_response.text
            
            # Check if special characters are properly escaped
            if r'\&' in latex_content and r'\%' in latex_content and r'\_' in latex_content:
                print("✅ Special characters properly escaped in LaTeX")
            else:
                print("❌ Special characters not properly escaped")
                print("LaTeX content preview:")
                print(latex_content[:500] + "...")
        else:
            print(f"❌ LaTeX preview failed: {preview_response.status_code}")
            print(f"Error: {preview_response.text}")
            return False
        
        # Test PDF generation
        print("\n2. Testing PDF generation...")
        pdf_response = requests.post(
            'http://localhost:5000/api/generate-resume',
            json=test_data,
            timeout=60
        )
        
        if pdf_response.status_code == 200:
            print("✅ PDF generation successful")
            with open('test_special_chars.pdf', 'wb') as f:
                f.write(pdf_response.content)
            print("📄 PDF saved as 'test_special_chars.pdf'")
            return True
        else:
            print(f"❌ PDF generation failed: {pdf_response.status_code}")
            print(f"Error: {pdf_response.text}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Connection error: Make sure Flask app is running on localhost:5000")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False

if __name__ == "__main__":
    success = test_special_characters()
    if success:
        print("\n🎉 All special character tests passed!")
    else:
        print("\n💥 Some tests failed!")

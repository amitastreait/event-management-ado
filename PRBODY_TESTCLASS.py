import re
import argparse

def extract_apex_classes(pr_body):
    """
    Extract Apex test class names from the PR body.

    Args:
        pr_body (str): The PR description/body as a string.

    Returns:
        str: A space-separated string of Apex class names or an error message.
    """
    # Using regex to extract the test class names from the last line
    match = re.search(r"APEX TEST CLASS TO RUN \[RUN:([^\]]+)\]", pr_body)
    if match:
        apex_classes = match.group(1).split(',')
        apex_classes_string = ' '.join(cls.strip() for cls in apex_classes)
        return apex_classes_string
    else:
        return "No Apex classes found"

if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Extract Apex test classes from PR body.")
    parser.add_argument("pr_body", type=str, help="The PR body text")

    # Parse arguments
    args = parser.parse_args()
    # Extract and print Apex test classes
    result = extract_apex_classes(args.pr_body)
    print(result)

    # Set Azure DevOps variable
    print(f"##vso[task.setvariable variable=APEX_CLASSES;isOutput=true]{result}")

# python PRBODY_TESTCLASS.py "This PR contains some updates. APEX TEST CLASS TO RUN [RUN:TestClass1, TestClass2, TestClass3]"
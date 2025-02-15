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
    print(pr_body)
    # Using regex to extract the test class names from the last line
    match = re.search(r"APEX TEST CLASS TO RUN \[RUN:([^\]]+)\]", pr_body)
    if match:
        apex_classes = match.group(1).split(',')
        apex_classes_string = ' '.join(cls.strip() for cls in apex_classes)
        return apex_classes_string
    else:
        return "No Apex classes found"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract Apex test classes from PR body file.")
    parser.add_argument("file_path", type=str, help="Path to the PR body file")

    args = parser.parse_args()

    # Read PR body from file
    with open(args.file_path, "r", encoding="utf-8") as file:
        pr_body = file.read().strip()

    result = extract_apex_classes(pr_body)

    # Print result normally
    print(result)

    # Set Azure DevOps variable
    print(f"##vso[task.setvariable variable=APEX_CLASSES;isOutput=true]{result}")
import subprocess
import sys

try:
    [arg] = sys.argv[1:]
except:
    print("NOTE- Needs atleast one argument"
          "Please enter one of the following args: "
          "\ninit, \nversion, \nshow, \nplan, \napply")
    sys.exit(1)

# Terraform variables
if arg == 'plan' or arg == 'apply':
    region = str(raw_input("Default is us-east-1. Enter the region >> "))
    aws_region = "AWS_REGION=" + region

    instances = str(raw_input("Default is 3 for each subnet. Enter no of instances >> "))
    no_of_instances = "NO_OF_INSTANCES=" + instances

    ami = str(raw_input("Default is ami-04169656fea786776. Enter the AMI >> "))
    aws_ami = "AMI=" + ami

# Various terraform functionalities
if arg == 'show':
    process = subprocess.Popen(['terraform', 'show'],
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    stdout, stderr
    print(stdout)

elif arg == 'version':
    process = subprocess.Popen(['terraform', 'version'],
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    stdout, stderr
    print(stdout)

elif arg == 'init':
    process = subprocess.Popen(['terraform', 'init'],
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    stdout, stderr
    print(stdout)

elif arg == 'plan':
    process = subprocess.call(['terraform', 'plan', '-var', aws_region,
                               '-var', no_of_instances, '-var', aws_ami, '-out=/tmp/output-plan.tf'])

elif arg == 'apply':
    process = subprocess.call(['terraform', 'apply', '-var', aws_region,
                               '-var', no_of_instances, '-var', aws_ami, '-auto-approve'])


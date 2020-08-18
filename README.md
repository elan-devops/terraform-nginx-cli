<summary>
This is a simple NGINX sever load balanced with ALB and ASG using Terraform and Python
</summary>

<h4>Usage:</h4>
 python cli.py [args]


<h4>Skeleton:</h4>
```bash
.
├── README.md
├── alb-asg.tf
├── cli.py
├── ec2-instances.tf
├── nginx.sh
├── nginx.tpl
├── provider.tf
├── secgroup.tf
├── terraform-cli.pem
├── terraform.tfstate
├── terraform.tfstate.backup
├── variables.tf
└── vpc.tf
```

<h4>Pre-requisites:</h4>
<h5>Install Terraform </h5>
 <ul>
  STEP 1:
 <ol>
  <li> Terraform v0.13.0 </li>
  <li> provider registry.terraform.io/hashicorp/aws v3.2.0 </li>
 </ol>
  
  STEP 2:
   <ol>
   <li>  ADD AWS credentials in ~/.aws/config </li>
  Example:
    <p>
    [default]
    aws_access_key_id = Access key 
    aws_secret_access_key = Secret_key 
    </p>
    </li>
  </ol>
  STEP 3:
  Create aws keypair to ssh access to ec2 instances
 </ul>
 
 
 <h3>Description:</h3>
 <p> VPC - CIDR of 192.168.0.0/16 with Public Subnet for each AZs</p>
 <p> SG - Ingress on 80 and ssh connection </p>
 <p> ASG-ALB Min - 2, Max: 6 Health check on EC2 with sg for port 80</p>
 <p> Output - LB DNS URL </p>

<h3> Improvement </h3>
<p> Instead of "provisioner - ssh connection/ remote-exec" --> "user-data"
<p> Cli - arg parser </p>
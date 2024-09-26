

Problem statement
The goal is to automate the creation of three separate golden images every friday from base images for Ubuntu, Amazon Linux, and Windows operating systems. Each golden image should be built only after successfully scanning for security vulnerabilities. A detailed vulnerability report for each image should be generated and uploaded to a specified Amazon S3 bucket for future reference and audit.

Motivation
Creating secure and standardized system images, also known as golden images, is crucial for ensuring consistency, security, and compliance across production environments
Manually building and validating these images is error-prone and time-consuming.
Ensuring that no image is deployed with security vulnerabilities is critical, especially for environments handling sensitive data or running critical applications.

Requirement
Base Images: To begin with use aws provided base images for Ubuntu, Amazon Linux, and Windows operating systems
Packages: Base images must be kept up to date with the latest patches, packages and security updates.
Vulnerability Scanning: Before creating a golden image, each base image must undergo an automated security vulnerability scan.
Automation: The entire process must be automated and triggered periodically (e.g., weekly) or on-demand.
Frequency: Golden image automation pipeline must run every friday.
Tools: Tools such as AWS Image Builder, AWS Inspector, AWS S3, AWS SNS may be used to automate this workflow.
Persist report: Vulnerability reports are automatically uploaded to the S3 bucket after every scan.
Notifications: Failure notifications should be sent in case the process halts due to security vulnerabilities.
Proposed Architecture



Approach

AWS Image Builder Component
The AWS Image Builder Component is a core part of AWS Image Builder, a service that simplifies the creation, management, and automation of customized system images for EC2. A component defines a sequence of steps for downloading, installing, and configuring software packages or for defining tests to run on software packages to apply to the base image during the build process.







In our setup, we will create three separate components: 
Ubuntu component
Platform - Linux
Supported OS version - 22.04
Amazon Linux component
Platform - Linux
Supported OS version - Amazon Linux 2023
Windows component
Platform - Windows
Supported OS version - Microsoft Windows Server 2022
Each component will be tailored to the specific requirements of the respective operating system, ensuring that the appropriate software packages, configurations, and testing steps are executed for each environment.

AWS Image Builder Receipe
The AWS Image Builder Recipe defines how an image will be created. It acts as a blueprint for building customized system images (AMIs) by specifying the base image, the components to be applied (such as software packages or configurations), and the build process instructions.
Each Image Recipe includes the following key elements:
Versioning: Each image recipe is versioned, allowing for better tracking of changes across different image builds.
Base Image: The initial OS image (e.g., Ubuntu, Amazon Linux, or Windows) from which the customized image will be built.
Components: A list of AWS Image Builder components that define the actions to be taken during the build process, such as software installation, configuration, and testing.
Storage (volumes): To encrypt volumes for the images that Image Builder creates, you must use the storage volume encryption in the image recipe.
Working Directory: location where components in the recipe will perform actions such as downloading, installing, or configuring software.



In our setup, we will create three separate recipe: 
Ubuntu recipe
Version : 1.0.0
Base AMI : <AWS Managed AMI>
Device Name : /dev/xvdb
Volume Type : I01
Volume Size : 300 GB
EBS IOPS : 15000
User Data : ubuntu_bootstrap.sh
Working Dir : /tmp
Amazon Linux recipe
Version : 1.0.0
Base AMI : <AWS Managed AMI>
Device Name : /dev/xvdb
Volume Type : I01
Volume Size : 300 GB
EBS IOPS : 15000
User Data : amazon_linux_bootstrap.sh
Working Dir : /tmp
Windows recipe
Version : 1.0.0
Base AMI : <AWS Managed AMI>
Device Name : /dev/xvdb
Volume Type : I01
Volume Size : 300 GB
EBS IOPS : 15000
User Data : windows_bootstrap.ps
Working Dir : C:/
Note: 
The windows_bootstrap.ps script is executed by powershell.exe on Windows. It runs with system-level permissions, allowing you to make changes to the system environment.

AWS Infrastructure Configuration
Image Builder launches EC2 instances in your account to customize images and run validation tests. The Infrastructure configuration settings specify infrastructure details for the instances that will run in your AWS account during the build process.




In our setup, we will create one common infrastructure configuration for all Image Builder pipelines.
Instance type : c5n.4xlarge
Security Group Inbound Port : SSH(22) , HTTP(80) , HTTPs(443)
Security Group Outbound Port : HTTPs(443) 


AWS Image Distribution
Choose the AWS Regions to distribute your image to after the build is complete and has passed all its tests. The pipeline automatically distributes your image to the Region where it runs the build, and you can add image distribution for other Regions.

In our setup, we will have 3 distribution with below details
Ubuntu pipeline distribution
Region : US-WEST-2 
AWS Account : 
Tag: ubuntu
Amazon Linux distribution
Region : US-WEST-2 
AWS Account : 
Tag: amazon-ami
Windows distribution
Region : US-WEST-2 
AWS Account : 
Tag: Windows

AWS Image Builder Workflow
EC2 Image Builder launches image workflows to customize image creation process. With image workflows, Image Builder allows customers to add new processes, exclude steps, or replace default processes of their image creation setup. Once customized, a saved image workflow is a new resource that can be used across your image creation setup in Image Builder.

In our setup, we will create a common workflows for all pipelines:

Workflow Steps:
LaunchTestInstance:
Action: Launches a test EC2 instance.
Failure Handling: Abort on failure.
Inputs: Waits for the SSM Agent to be available.
CollectFindingsStep:
Action: Collects vulnerability findings from the image scan.
Failure Handling: Abort on failure.
Inputs: Uses the instance ID from the previous step (LaunchTestInstance).

NotifyOnFailure:
Action: aws:runCommand <aws sns publish --topic-arn ….. instance: $(instanceId)>
Failure Handling: Continue on failure.
Inputs: Uses the instance ID from the previous step (LaunchTestInstance).

CreateImageFromInstance:
Action: Creates an AMI from the test instance.
Failure Handling: Abort on failure.
Inputs: Uses the instance ID from LaunchTestInstance.
TerminateTestInstance:
Action: Terminates the test EC2 instance.
Failure Handling: Continue on failure.
Inputs: Uses the instance ID from LaunchTestInstance.
WaitForActionAtEnd:
Action: Waits for an external action at the end of the workflow.
Condition: Executes only if the parameter waitForActionAtEnd is set to true.

AWS Image Pipeline
AWS Image Builder make use of component, recipie, Infrastructure and Workflow to automates the creation, maintenance, testing, and distribution of custom Amazon Machine Images (AMIs). It defines a repeatable process for building secure and standardized images, ensuring that images are kept up to date with the latest security patches, software updates, and configurations.
In our setup, we will create three separate image pipeline: 
Ubuntu pipeline
Schedule : cron(0 8 ? * FRI *)
Timezone : East time zone
Componenet : Ubuntu component
Receipe : Ubuntu recipe
Role : Workflow execution role
Distribution : 
Amazon Linux pipeline
Schedule : cron(0 8 ? * FRI *)
Timezone : East time zone
Componenet : Amazon Linux component
Receipe : Amazon Linux recipe
Role : Workflow execution role
Windows pipeline
Schedule : cron(0 8 ? * FRI *)
Timezone : East time zone
Componenet : Windows component
Receipe : Windows recipe
Role : Workflow execution role

AWS Systems Manage
AWS Systems Manager gathers data about your instances and the software they run, allowing you to better understand your system configurations and installed applications.
Data on apps, files, network configurations, Windows services, registries, server roles, updates, and other system attributes can be collected.
You can use the information acquired to manage application assets, track licensing, check file integrity, and find apps that aren’t installed by a standard installer, among other things.



AWS SSM Agent
The AWS Systems Manager Agent (SSM Agent) is Amazon software that is preinstalled on Amazon EC2 instances created out of base images provided by amazon. 
Systems Manager may update, manage, and configure these resources using the SSM Agent. 
The agent receives requests from the AWS Cloud’s Systems Manager service and executes them as stated in the request. The SSM Agent then uses the Amazon Message Delivery Service (service prefix: ec2messages) to deliver status and execution information back to the Systems Manager service.
Check the status of SSM Agent by running the command for your instance's operating system type.

Operating system
command
Ubuntu Server (64-bit - Deb)
sudo systemctl status amazon-ssm-agent
Amazon Linux 2023
sudo systemctl status amazon-ssm-agent
Windows Server
Get-Service AmazonSSMAgent

AWS SNS Service
To send an email notification using AWS Simple Notification Service (SNS) when image scanning fails in an AWS Image Builder pipeline, you can integrate SNS with the pipeline’s workflow. By using a failure condition in the pipeline (e.g., a failed image scan step), you can trigger SNS to send an email notification.
In our workflow setup, we will add below steps after image scanning : 
CollectFindingsStep: This step runs the image scan on the launched instance.
NotifyOnFailure: If the image scan fails, this step will publish a message to the SNS topic (ImageBuilderFailureNotifications) with the instance ID, notifying the user that the scan failed.
AWS-RunShellScript: The aws sns publish command sends a notification to the SNS topic when invoked.

AWS Inspector
If you've activated Amazon Inspector for your account, Amazon Inspector automatically scans the EC2 instances that Image Builder launches to build and test a new image.
Amazon Inspector is a paid service.
EC2 instances brought up in image pipeline have a short lifespan during the build and test process, and their findings would normally expire as soon as those instances shut down. 
To help you investigate and remediate findings for your new image, Image Builder can optionally save any findings that Amazon Inspector identified on your EC2 instance during the build process as a csv file on S3 bucket.

Reference : 

https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-imagebuilder-component.html

https://docs.aws.amazon.com/imagebuilder/latest/userguide/create-image-recipes.html

https://docs.aws.amazon.com/imagebuilder/latest/userguide/how-image-builder-works.html

Amazon Inspector integration in Image Builder

Time zone for pipeline

Find AMIs with the SSM Agent preinstalled


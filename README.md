<a id="readme-top"></a>



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/fahd04/terraform-aws">
    <img src="/aws-terraform.jpg" alt="Logo" width="80" height="80">
  </a>
  <h3 align="center">Provisioning AWS Infrastructure with Terraform</h3>
  <p align="center">
    <br />
    <a href="https://github.com/fahd04/terraform-aws"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/fahd04/terraform-aws">View Demo</a>
    ·
    <a href="https://github.com/fahd04/terraform-aws/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/fahd04/terraform-aws/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

# 🌍 Infrastructure as Code with AWS & Terraform

As part of a larger full-stack application, I recently delved into **Infrastructure as Code (IaC)**, leveraging **AWS** and **Terraform** to streamline infrastructure provisioning.

## 🛠️✨ Automated Infrastructure Provisioning
Instead of manually configuring AWS infrastructure for testing, I utilized Terraform's powerful capabilities to automate the process.

### 📖 What is Terraform?
**Terraform** is an open-source IaC tool developed by **HashiCorp**. It allows you to define and provision cloud infrastructure using a declarative configuration language.

## 🌍 Project Highlights
- 🚀 **Deployed two EC2 instances**: One for the backend and another for the frontend, each residing in separate public subnets.
- 💾 **MySQL RDS Database**: Orchestrated the deployment of a database spread across two subnets for enhanced performance.
- 🔒 **Security Groups**: Implemented security rules to control traffic between backend, frontend, and database for secure communication.
- 🌐 **Custom VPC with Internet Gateway**: Enabled HTTP & SSH access for backend and frontend developers via a Terraform-managed VPC.

## 🧩 Why I Chose IaC:
- **Efficiency Boost**: Quickly set up and tear down AWS resources for testing, eliminating manual configuration.
- **Scalability in Focus**: Designed a modular, scalable infrastructure that adapts to the evolving needs of the project.


<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

This section highlights the key frameworks and libraries used to build your project.

* [![Terraform][Terraform]][Terraform-url]
* [![AWS][AWS]][AWS-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Follow the steps below to run the Terraform script and automate AWS infrastructure provisioning.

1. **Clone the repository**:
   ```sh
   git clone https://github.com/fahd04/terraform-aws-setup.git
   ```

2. **Navigate to the Terraform project directory**:
   ```sh
   cd terraform-aws-setup
   ```

3. **Initialize Terraform** (this downloads the required providers and modules):
   ```sh
   terraform init
   ```

4. **Validate the Terraform configuration** to ensure it's correct:
   ```sh
   terraform validate
   ```

5. **Preview the infrastructure changes** (optional but recommended):
   ```sh
   terraform plan
   ```

6. **Apply the Terraform configuration** to provision the infrastructure:
   ```sh
   terraform apply
   ```
   _You will be prompted to confirm. Type `yes` to proceed._

7. **Change the git remote URL** to avoid accidental pushes to the original project:
   ```sh
   git remote set-url origin github_username/repo_name
   git remote -v # confirm the changes
   ```

Once the script is executed, the AWS infrastructure will be provisioned as defined in the Terraform configuration.


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Fahd Rahali - [LinkedIn](https://www.linkedin.com/in/fahd-rahali-77b02526a/) - fahdrahali43@gmail.com

Project Link: [https://github.com/fahd04/terraform-aws](https://github.com/fahd04/terraform-aws)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/fahd04/terraform-aws.svg?style=for-the-badge
[contributors-url]: https://github.com/fahd04/terraform-aws/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/fahd04/terraform-aws.svg?style=for-the-badge
[forks-url]: https://github.com/fahd04/terraform-aws/network/members
[stars-shield]: https://img.shields.io/github/stars/fahd04/terraform-aws.svg?style=for-the-badge
[stars-url]: https://github.com/fahd04/gest-app/stargazers
[issues-shield]: https://img.shields.io/github/issues/fahd04/terraform-aws.svg?style=for-the-badge
[issues-url]: https://github.com/fahd04/terraform-aws/issues
[license-shield]: https://img.shields.io/github/license/fahd04/terraform-aws.svg?style=for-the-badge
[license-url]: https://github.com/fahd04/terraform-aws/blob/main/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/fahd-rahali-77b02526a/
[product-screenshot]: /infra-graph.jpeg
[Terraform]: https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white
[Terraform-url]: https://developer.hashicorp.com/terraform/docs
[AWS]: https://img.shields.io/badge/AWS-%23232f3e?logo=amazon
[AWS-url]: https://docs.aws.amazon.com/

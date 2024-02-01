resource "aws_key_pair" "terraform_kp" {
    key_name = "terraform_kp"
    public_key = file("terraform_kp.pub")
}
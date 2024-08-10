resource "aws_db_subnet_group" "aws_db_subnet_group" {

  subnet_ids =  var.subnetids 
   tags = {
    Name = "My DB subnet group"
  }
  
}

# Output: Instance IDs from aws_instance.hyd_machine
/* output "instance_ids" {
  value = tomap({
    for k, inst in aws_instance.hyd_machine : k => inst.id
  })
} */


/* Uncomment this if you're using a single instance
 output "instance_id" {
   value = aws_instance.hyd_machine.id
 }

 Uncomment this if you're using count instead of for_each
 output "private_HYD_dns_count" {
   value = aws_instance.hyd_machine[*].private_dns
 } */



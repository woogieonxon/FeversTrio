output "repository_url" {
  value       = aws_ecr_repository.ecr_repo.repository_url
  description = "The URL of the repository."
}

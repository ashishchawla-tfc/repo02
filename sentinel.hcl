import "tfrun"

is_dev = rule {
  // Check that workspace has tags and contains "dev"
  tfrun.workspace.tags is not empty and
  tfrun.workspace.tags contains "dev"
}

main = rule {
  is_dev
}

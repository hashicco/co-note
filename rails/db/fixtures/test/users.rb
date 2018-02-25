
yaml_string = <<~YAML
  - id: 1
    email: "jon@example.com"
    name: "Jon"
  - id: 2
    email: "emily@example.com"
    name: "Emily"
YAML

User.seed :id, *( YAML.load(yaml_string) )

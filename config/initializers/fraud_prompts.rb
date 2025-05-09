module FraudPromptConfig
  CONFIG = YAML.load_file(
    Rails.root.join("config", "fraud_prompts.yml")
  ).with_indifferent_access
end

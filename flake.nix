outputs = { self }: {
  templates.app = {
    path = ./template;
    description = "A python project using poetry2nix with direnv environment";
  };
  templates.default = self.templates.app;
}

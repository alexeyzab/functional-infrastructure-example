let
  vbox =
    { config, pkgs, ... }:
    {
      deployment.targetEnv = "virtualbox";
      deployment.virtualbox.memorySize = 512;
      deployment.virtualbox.headless = true;
    };
  ec2 =
    { resources, pkgs, lib, nodes, ...}:
    {
      deployment.targetEnv = "ec2";
      deployment.ec2.region = "us-west-2";
      deployment.ec2.instanceType = "t2.micro";
      deployment.ec2.keyPair = resources.ec2KeyPairs.nixed;
    };
  target = ec2;
in
  {
    network.description = "nixed";
    network.enableRollback = true;

    resources.ec2KeyPairs.nixed.region = "us-west-1";

    backend = target;
  }

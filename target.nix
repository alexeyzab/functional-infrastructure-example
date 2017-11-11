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
    resources.rdsDbInstances.nixed = {
      region = "us-west-2";
      id = "nixed";
      instanceClass = "db.t2.micro";
      allocatedStorage = 5;
      masterUsername = "master";
      masterPassword = "master";
      port = 5432;
      engine = "postgres";
      dbName = "nixed";
    };

    resources.ec2KeyPairs.nixed.region = "us-west-1";

    backend = target;
    backend2 = target;
    backend3 = target;
    frontend = target;
    proxy = target;
  }

{inputs, ...}: {
	sops.age.sshKeyPaths = [ "/home/aurora/.ssh/id_ed25519" ];
	sops.validateSopsFiles = true;
}

{inputs, ...}: {
	sops.age.sshKeyPaths = [ "/home/aurora/.ssh/id_ed25519" ];
	sops.age.generateKey = true;
}

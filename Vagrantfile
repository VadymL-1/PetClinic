# Vagrantfile
DB_NAME = ENV.fetch("DB_NAME", "petclinic")
DB_USER = ENV.fetch("DB_USER", "petuser")
DB_PASS = ENV.fetch("DB_PASS", "ChangeMe123!")
DB_PORT = ENV.fetch("DB_PORT", "3306")
DB_IP   = "192.168.56.11"
APP_IP  = "192.168.56.10"

Vagrant.configure("2") do |config|
  config.vm.box = "cloud-image/ubuntu-26.04"

  config.vm.define "db" do |db|
    db.vm.hostname = "db-vm"
    db.vm.network "private_network", ip: DB_IP
    db.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end
    db.vm.provision "shell", path: "scripts/db.sh",
      env: { "DB_NAME" => DB_NAME, "DB_USER" => DB_USER,
             "DB_PASS" => DB_PASS, "DB_IP" => DB_IP, "APP_IP" => APP_IP }
  end

  config.vm.define "app" do |app|
    app.vm.hostname = "app-vm"
    app.vm.network "private_network", ip: APP_IP
    app.vm.network "forwarded_port", guest: 8080, host: 8080
    app.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    app.vm.provision "shell", path: "scripts/vm.sh",
      env: { "DB_HOST" => DB_IP, "DB_PORT" => DB_PORT, "DB_NAME" => DB_NAME,
             "DB_USER" => DB_USER, "DB_PASS" => DB_PASS,
             "REPO_URL" => ENV.fetch("REPO_URL", "https://github.com/VadymL-1/PetClinic.git") }
  end
end
let
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8xT9HhoGiWOEn++CHZGHKLbtf8+zt9OMQHcaVQbLfK gustavomendes.medeiros@gmail.com";
in
{
  "anthropic-api-key.age" = {
    publicKeys = [ macbook ];
    armor = true;
  };
  "borg-passphrase.age" = {
    publicKeys = [ macbook ];
    armor = true;
  };
  "email.age" = {
    publicKeys = [ macbook ];
    armor = true;
  };
  "msmtp-config.age" = {
    publicKeys = [ macbook ];
    armor = true;
  };
}

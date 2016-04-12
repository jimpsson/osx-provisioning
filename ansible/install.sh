# brew/brew-cask
ansible-playbook -i hosts -vv osx.yml
# default config
ansible-playbook -i hosts -vv osx_defaults.yml
# font
ansible-playbook -i hosts -vv ricty.yml

# home.nix
{ config, pkgs, ... }:

{
  # Домашняя директория по умолчанию устанавливается автоматически.
  home.username = "iershov";
  home.homeDirectory = "/home/iershov";
  
  # Позволяет home-manager управлять некоторыми файлами-ссылками (dotfiles).
  # Это безопасно и рекомендуется для начинающих.
  home.stateVersion = "24.11"; # Укажите версию, соответствующую вашему nixpkgs

  # Установка пакетов для пользователя. Vim будет доступен в PATH.
  home.packages = with pkgs; [
    vim            # Устанавливаем Vim
    # Другие утилиты можно добавить сюда же, например:
    # git
    # htop
    # curl
  ];

  # Базовые настройки Vim через Home Manager (опционально, но очень удобно)
  programs.vim = {
    enable = true;
    # Можно задать настройки по умолчанию для всех пользователей системы
    defaultEditor = true;
    settings = {
      ignorecase = true;   # Игнорировать регистр при поиске
      smartcase = true;    # Но не игнорировать, если есть заглавные буквы
      number = true;       # Показывать номера строк
      relativenumber = true; # Показывать относительные номера строк
    };
    extraConfig = ''
      " Дополнительные пользовательские настройки Vimscript
      syntax on
      set tabstop=2
      set shiftwidth=2
      set expandtab
    '';
  };

  # Этот параметр управляет созданием ~/.nix-profile и нужен для home-manager
  programs.home-manager.enable = true;
}

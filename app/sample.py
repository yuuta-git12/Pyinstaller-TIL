# main.py
import configparser
import tkinter as tk
from tkinter import messagebox
from pathlib import Path
import traceback
import os
import sys


def on_button_click():
    messagebox.showinfo("Information", "Hello, World!")


def read_config():
    try:
        # 実行ファイルと同じディレクトリにあるconfig.iniを探す
        settings_file_path = Path(os.path.dirname(os.path.abspath(sys.argv[0])))/'settings.ini'

        # ファイルが存在するか確認
        if not settings_file_path.exists:
            raise FileNotFoundError(f"{settings_file_path} not found.")

        # configparserで.iniファイルを読み込む
        config = configparser.ConfigParser()
        config.read(settings_file_path)

        if not config.has_section('settings'):
            print("Error: No section 'settings' found in config file.") 
            return None  # セクションが見つからなかった場合はNoneを返す

        print(config['settings']['username'])

        username = config.get("settings", "username")
        password = config.get("settings", "password")

        print(f"Username: {username}")
        print(f"Password: {password}")

        return username, password
    except Exception as e:
        print(f"Error: {e}")
        traceback.print_exc()


result = read_config()

root = tk.Tk()
root.title(result[0])
root.geometry("300x200")

button = tk.Button(root, text=result[1], command=on_button_click)
button.pack(pady=20)

root.mainloop()

from tkinter import *
import tkinter.font as font
from tkinter import messagebox as mb, ttk
from PIL import Image, ImageTk
from Database import Database

from Table import ShowTable


class GUI:
    def __init__(self):
        self.root = None
        self.sign_in_button = None
        self.main_menu = None
        self.tab_control = None
        self.database = Database()
        self.show_table = []

    def create_root(self):
        self.root = Tk()
        self.root.title("Database - Pharmacy")
        w = 880
        h = 580
        sw = self.root.winfo_screenwidth()
        sh = self.root.winfo_screenheight()
        x = (sw - w) / 2
        y = (sh - h) / 2
        self.root.geometry('%dx%d+%d+%d' % (w, h, x, y))
        self.root.resizable(False, False)
        image = Image.open("bg_1.jpg")
        photo = ImageTk.PhotoImage(image)
        background_image = photo
        background_label = Label(self.root, image=background_image)
        background_label.place(x=0, y=0, relwidth=1, relheight=1)
        background_label.image = background_image
        self.main_menu = Menu(self.root)

        def create_database():
            if not self.database.create_database():
                mb.showerror("Create database", "Database already exist")
            self.create_tab_control()
            if not self.show_table:
                for i, table in enumerate(self.database.tables):
                    temp = ShowTable(table, self.tab_control)
                    self.show_table.append(temp)
                    temp.show()

        self.main_menu.add_command(label='Create database', state='disabled', command=create_database)

        def delete_database():
            if self.database.drop_database():
                self.tab_control.destroy()
                self.tab_control = None
                self.show_table.clear()
            else:
                mb.showerror("Delete database", "Database does not exist")

        self.main_menu.add_command(label='Delete database', state='disabled', command=delete_database)

        def clear_all():
            if not self.database.clear_all_tables():
                mb.showerror("Clear all tables", "Database does not exist")
            else:
                for show_table in self.show_table:
                    show_table.create_tree_views()

        self.main_menu.add_command(label='Clear all tables', state='disabled', comman=clear_all)

        self.root.config(menu=self.main_menu)
        helv18 = font.Font(family='Helvetica', size=18, weight=font.BOLD)
        self.sign_in_button = Button(self.root, text='Sign in', background='#FCFCFC', font=helv18,  fg='#E8898D',
                                command=lambda: self.postgres_authentication())
        self.sign_in_button.place(rely=.02, relx=.44, height=50, width=100)
        def close_root():
            self.database.close_all()
            self.root.destroy()

        self.root.protocol('WM_DELETE_WINDOW', close_root)

    def create_tab_control(self):
        if self.tab_control is None:
            ttk.Style().map("TNotebook.Tab", foreground=[("!selected", '#D84951'), ("selected", '#34A4A3')])
            self.tab_control = ttk.Notebook(self.root)
            self.tab_control.pack(expand=1, fill='both')


    def postgres_authentication(self):
        def check():
            if not self.database.init_connection(username_entry.get(), password_entry.get()):
                mb.showerror("Error authentication", "Wrong username or password")
                extra_window.focus_set()
            else:
                self.sign_in_button.destroy()
                extra_window.destroy()
                self.main_menu.entryconfig('Create database', state='normal')
                self.main_menu.entryconfig('Delete database', state='normal')
                self.main_menu.entryconfig('Clear all tables', state='normal')
                self.create_tab_control()
                if self.database.is_exists:
                    for i, table in enumerate(self.database.tables):
                        temp = ShowTable(table, self.tab_control)
                        self.show_table.append(temp)
                        temp.show()

        extra_window = Toplevel(self.root)
        extra_window.title('Sign in')
        w = 230
        h = 120
        sw = extra_window.winfo_screenwidth()
        sh = extra_window.winfo_screenheight()
        x = (sw - w) / 2 - 10
        y = (sh - h) / 2 - 10
        extra_window.geometry('%dx%d+%d+%d' % (w, h, x, y))
        extra_window.resizable(False, False)
        extra_window.config(bg="#BAE7EA")
        helv10 = font.Font(family='Helvetica', size=10)
        Label(extra_window, text='Username', height=2, width=12, bg='#BAE7EA', font=helv10).grid(row=0, column=0)
        username_entry = Entry(extra_window)
        username_entry.insert(END, 'postgres')
        username_entry.grid(row=0, column=1)

        Label(extra_window, text='Password', height=2, width=12, bg='#BAE7EA', font=helv10).grid(row=1, column=0)
        password_entry = Entry(extra_window, show='*')
        password_entry.grid(row=1, column=1)

        button_sign_in = Button(extra_window, text='Sign in', command=check, font=helv10, bg='#FDE0E1')
        button_sign_in.grid(row=3, column=0, columnspan=2)
        button_sign_in.place(rely=.7, relx=.4, height=30, width=60)

if __name__ == '__main__':
    gui = GUI()
    gui.create_root()
    gui.root.mainloop()


from tkinter import ttk, font
from tkinter.ttk import Frame, Treeview
from tkinter import *
from enum import Enum

class Table:
    def __init__(self, name, columns: list, database):
        self.name = name
        self.columns = columns
        self.database = database

    def get_records(self) -> list:
        self.database.cursor.execute("SELECT * FROM get_{}()".format(self.name))
        result = self.database.cursor.fetchall()
        return result

    def get_record_by_id(self, record_id):
        self.database.cursor.execute("SELECT get_record_by_id('{}', {})".format(self.name, record_id))
        result = self.database.cursor.fetchall()
        return result

    def clear_table(self):
        self.database.cursor.execute("SELECT clear_table('{}')".format(self.name))
        result = self.database.cursor.fetchall()
        self.database.conn.commit()
        return result

    def insert(self, *args):
        if type(*args) == tuple:
            self.database.cursor.execute("SELECT insert_into_{}{}".format(self.name, *args))
        else:
            self.database.cursor.execute("SELECT insert_into_{}('{}')".format(self.name, *args))
        self.database.conn.commit()
        return self.get_records()

    def update_record(self, *args):
        if type(*args) == tuple:
            self.database.cursor.execute("SELECT update_{}{}".format(self.name, *args))
        else:
            self.database.cursor.execute("SELECT update_{}('{}')".format(self.name, *args))
        self.database.conn.commit()
        return self.get_records()

    def delete_record(self, record_id: int):
        self.database.cursor.execute("SELECT delete_record_from_table({}, '{}')".format(record_id, self.name))
        self.database.conn.commit()
        return self.get_records()


class TableAdditionByAddress(Table):
    def __init__(self, name, columns: list, cursor):
        super().__init__(name, columns, cursor)

    def search_by_address(self, address: str):
        self.database.cursor.execute("SELECT * FROM search_{}_by_address('{}')".format(self.name, address))
        result = self.database.cursor.fetchall()
        return result

    def delete_by_address(self, address: str):
        self.database.cursor.execute("SELECT delete_{}_by_address('{}')".format(self.name, address))
        self.database.conn.commit()
        return self.get_records()

class TableAdditionByName(Table):
    def __init__(self, name, columns: list, cursor):
        super().__init__(name, columns, cursor)

    def delete_by_name(self, name: str):
        self.database.cursor.execute("SELECT delete_{}_by_name('{}')".format(self.name, name))
        self.database.conn.commit()
        return self.get_records()

class ShowTable:
    def __init__(self, table, table_control):
        self.table = table
        self.table_control = table_control
        self.tab = Frame(table_control, bg='#BAE7EA')
        self.frame_buttons = Frame(self.tab)
        self.frame_tree_view = Frame(self.tab)
        self.tree = None
        ttk.Style().map("Treeview.Heading", foreground=[("!selected", '#D84951')])
        self.scrollbarx = Scrollbar(self.frame_tree_view, orient=HORIZONTAL)
        self.scrollbary = Scrollbar(self.frame_tree_view, orient=VERTICAL)

    def create_tree_views(self, data: list = None):
        if self.tree:
            self.tree.destroy()
            self.tab.update()
        self.tree = Treeview(self.frame_tree_view, columns=self.table.columns,
                             height=400, selectmode="extended",
                             yscrollcommand=self.scrollbary.set, xscrollcommand=self.scrollbarx.set)
        self.scrollbary.config(command=self.tree.yview)
        self.scrollbary.pack(side=RIGHT, fill=Y)
        self.scrollbarx.config(command=self.tree.xview)
        self.scrollbarx.pack(side=BOTTOM, fill=X)

        for i in self.table.columns:
            self.tree.heading(i, text=i, anchor=CENTER)

        self.tree.column('#0', stretch=NO, minwidth=0, width=0)
        for i in range(1, len(self.table.columns)):
            self.tree.column('#' + str(i), stretch=NO, minwidth=100, width=150)

        if data is None:
            data = self.table.get_records()

        if data:
            for i in data:
                self.tree.insert("", 0, values=i)
        self.tree.pack(side=BOTTOM)

    class Operations(Enum):
        ADD = 1
        UPDATE = 2
        DELETE_BY_ID = 3
        DELETE_BY = 4
        SEARCH_BY = 5

    def create_extra_window(self, function, columns: list = None, fill_entry=False):
        entry_dict = {}

        extra_window = Toplevel(self.tab)
        extra_window.title("Окошко для ввода данных")
        w = self.tab.winfo_screenwidth()
        h = self.tab.winfo_screenheight()
        w = w // 2 + 150
        h = h // 2 - 300
        extra_window.config(bg="#BAE7EA")
        helv10 = font.Font(family='Helvetica', size=10)
        extra_window.geometry('+{}+{}'.format(w, h))
        extra_window.resizable(False, False)

        if columns:
            for i, column in enumerate(columns):  # except ID
                lbl = Label(extra_window, text=column, height=2, width=30, bg='#BAE7EA', font=helv10)
                lbl.grid(column=0, row=i + 2, pady=10)
                txt = Entry(extra_window, width=25)
                txt.grid(column=1, row=i + 2, columnspan=2, pady=10, padx=10)
                entry_dict[column] = txt

        if fill_entry:
            self.fill_entries(entry_dict)

        def update_tree():
            def process_data() -> tuple:
                result = []
                for key in entry_dict:
                    value = entry_dict[key].get()
                    if value.isdigit():
                        result.append(int(value))
                    else:
                        result.append(value)
                if len(result) == 1:
                    return result[0]
                return tuple(result)

            data = function(process_data())
            self.create_tree_views(data)

        helv10 = font.Font(family='Helvetica', size=10)
        button = Button(extra_window, text="OK", width=40, font=helv10, bg='#FDE0E1',
                        command=lambda: update_tree())
        button.grid(column=0, row=8, columnspan=3, padx=10, pady=30)

    def fill_entries(self, entry_dict: dict):
        for key in entry_dict:
            entry_dict[key].config(state='disable')
        entry_dict['id_'+self.table.name].config(state='normal')
        entry_dict['id_'+self.table.name].bind('<Return>', lambda x: fill(entry_dict['id_'+self.table.name].get()))

        def fill(record_id):
            result = self.table.get_record_by_id(record_id)
            result = result[0][0][1:-1].split(',')
            print(result)
            if self.table.name == 'pharmacy_medicine':
                result = result[:-1]
            for column, value in zip(entry_dict, result):
                entry_dict[column].config(state='normal')
                entry_dict[column].delete(0, END)
                entry_dict[column].insert(0, value)
            entry_dict['id_'+self.table.name].config(state='disabled')

    def create_function_window(self, operation):
        if operation == self.Operations.ADD:
            if self.table.name == 'pharmacy_medicine':
                self.create_extra_window(self.table.insert, self.table.columns[1:-1])
            else:
                self.create_extra_window(self.table.insert, self.table.columns[1:])

        elif operation == self.Operations.UPDATE:
            if self.table.name == 'pharmacy_medicine':
                self.create_extra_window(self.table.update_record, self.table.columns[:-3])
            else:
                self.create_extra_window(self.table.update_record, self.table.columns)

        elif operation == self.Operations.DELETE_BY_ID:
            self.create_extra_window(self.table.delete_record, [self.table.columns[0]])

        elif operation == self.Operations.DELETE_BY:
            if self.table.__class__.__name__ == 'TableAdditionByAddress':
                self.create_extra_window(self.table.delete_by_address, [self.table.columns[-1]])
            elif self.table.__class__.__name__ == 'TableAdditionByName':
                if self.table.name == 'medicine':
                    self.create_extra_window(self.table.delete_by_name, [self.table.columns[2]])
                else:
                    self.create_extra_window(self.table.delete_by_name, [self.table.columns[-1]])
        elif operation == self.Operations.SEARCH_BY:
            if self.table.__class__.__name__ == 'TableAdditionByAddress':
                self.create_extra_window(self.table.search_by_address, [self.table.columns[-1]])

    def show(self):
        add_button = Button(self.frame_buttons, text='Add record',
                            command=lambda: self.create_function_window(self.Operations.ADD), bg='#E6F5F7', fg='#D84951')
        add_button.pack(side=LEFT)

        update_button = Button(self.frame_buttons, text='Update record',
                               command=lambda: self.create_function_window(self.Operations.UPDATE), bg='#E6F5F7', fg='#D84951')
        update_button.pack(side=LEFT)

        delete_by_id_button = Button(self.frame_buttons, text='Delete record by id',
                                     command=lambda: self.create_function_window(self.Operations.DELETE_BY_ID), bg='#E6F5F7', fg='#D84951')
        delete_by_id_button.pack(side=LEFT)

        def clear():
            self.table.clear_table()
            self.create_tree_views()

        clear_button = Button(self.frame_buttons, text='Clear table', command=lambda: clear(), bg='#E6F5F7', fg='#D84951')
        clear_button.pack(side=LEFT)

        delete_by_button = Button(self.frame_buttons, text='Delete record(s) by',
                                          state='disabled' if self.table.__class__.__name__ == "Table" else 'normal',
                                        command=lambda: self.create_function_window(self.Operations.DELETE_BY), bg='#E6F5F7', fg='#D84951')
        delete_by_button.pack(side=LEFT)

        search_by_button = Button(self.frame_buttons, text='Search record(s) by',
                                         state='disabled' if (self.table.__class__.__name__ == "Table" or
                                                             self.table.__class__.__name__ == "TableAdditionByName") else 'normal',
                                         command=lambda: self.create_function_window(self.Operations.SEARCH_BY), bg='#E6F5F7', fg='#D84951')
        search_by_button.pack(side=LEFT)

        output_all_button = Button(self.frame_buttons, text='Refresh', command=lambda: self.create_tree_views(), bg='#E6F5F7', fg='#D84951')
        output_all_button.pack(side=LEFT)

        self.create_tree_views()
        self.table_control.add(self.tab, text=self.table.name)
        self.frame_buttons.pack()
        self.frame_tree_view.pack()


<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ex16.WebForm1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Student Management</title>
    <link href="style.css" rel="stylesheet" />
</head>

<body>
    <form id="form1" runat="server">
        <div>

            <asp:Label ID="lblID" runat="server" Text="ID :"></asp:Label>
            <asp:TextBox ID="txtID" runat="server"></asp:TextBox><br /><br />

            <asp:Label ID="lblName" runat="server" Text="Name :"></asp:Label>
            <asp:TextBox ID="txtName" runat="server"></asp:TextBox><br /><br />

            <asp:Label ID="lblAge" runat="server" Text="Age :"></asp:Label>
            <asp:TextBox ID="txtAge" runat="server"></asp:TextBox><br /><br />

            <asp:Button ID="btnInsert" runat="server" Text="Insert" OnClientClick="Insert(); return false;"/>
            <asp:Button ID="btnUpdate" runat="server" Text="Update" style="margin-left:20px;" OnClientClick="Update(); return false;"/><br /><br />

            <table style="width: 100%;" border="1">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Age</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="body">
                </tbody>
            </table>

        </div>
    </form>

    <script>
        let body = document.getElementById("body");
        let btnUpdate = document.getElementById("<%=btnUpdate.ClientID%>");
        btnUpdate.disabled = true;


        function show() {
            body.innerHTML = "";

            fetch("WebForm1.aspx/ShowStudents", { method: "POST", headers: { "content-type": "application/json; charset=utf-8" } }).then(response => response.json())
                .then(data => {
                    let students = data.d;
                    students.forEach(student => {

                        let row = document.createElement("tr");
                        row.dataset.id = student.ID;

                        let btnDelete = document.createElement("button");
                        btnDelete.onclick = function () { Delete(student.ID); };
                        btnDelete.innerText = "Delete";
                        btnDelete.type = "button";

                        let btnUpdate = document.createElement("button");
                        btnUpdate.innerText = "Edit";
                        btnUpdate.type = "button";
                        btnUpdate.onclick = function () { SelectEdit(student.ID); };

                        row.innerHTML = `
                            <td>${student.ID}</td>
                            <td>${student.Name}</td>
                            <td>${student.Age}</td>`;

                        let td = document.createElement("td");
                        td.appendChild(btnDelete);
                        td.appendChild(btnUpdate);
                        row.appendChild(td);
                        body.appendChild(row);
                    });
                });
        }

        function Delete(id) {
            fetch("WebForm1.aspx/DeleteStudent", { method: "POST", headers: { "content-type": "application/json; charset=utf-8" }, body: JSON.stringify({ id: id }) })
                .then(() => { show(); });
        }

        function Insert() {
            let id = document.getElementById("<%=txtID.ClientID%>").value;
            let name = document.getElementById("<%=txtName.ClientID%>").value;
            let age = document.getElementById("<%=txtAge.ClientID%>").value;

            let exists = Array.from(body.children).some(row => row.dataset.id === id.trim())
            if (exists) {
                alert("This ID already exists!");
                return;
            }

            fetch("WebForm1.aspx/AddStudent", { method: "POST", headers: { "content-type": "application/json; charset=utf-8" }, body: JSON.stringify({ id: id, name: name, age: age }) })
                .then(() => { show(); btnUpdate.disabled = true; });
        }

        function SelectEdit(id) {
            fetch("WebForm1.aspx/FindUpdateStudent", { method: "POST", headers: { "content-type": "application/json; charset=utf-8" }, body: JSON.stringify({ id: id }) }).then(response => response.json()).then(data => {
                let UpdatedStudent = data.d;
                document.getElementById("<%=txtID.ClientID%>").value = UpdatedStudent.ID;
                document.getElementById("<%=txtName.ClientID%>").value = UpdatedStudent.Name;
                document.getElementById("<%=txtAge.ClientID%>").value = UpdatedStudent.Age;
                btnUpdate.disabled = false;
            });
        }

        function Update() {
            let id = document.getElementById("<%=txtID.ClientID%>").value;
            let name = document.getElementById("<%=txtName.ClientID%>").value;
            let age = document.getElementById("<%=txtAge.ClientID%>").value;

            fetch("WebForm1.aspx/UpdateStudent", { method: "POST", headers: { "content-type": "application/json; charset=utf-8" }, body: JSON.stringify({ id: id, name: name, age: age }) }).then(response => response.json()).then(data => {
                let result = data.d;

                if (result) {
                    btnUpdate.disabled = true;
                    return;
                }

                else {
                    alert("Your ID is not valid!!")
                }
            })
                .then(() => { show(); });
        }

    </script>
</body>
</html>

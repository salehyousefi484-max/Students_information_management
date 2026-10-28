using System;
using System.Web.Services;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ex16
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class student
        {
            public int ID { get; set; }
            public string Name { get; set; }
            public int Age { get; set; }
        }

        static List<student> students = new List<student>();

        [WebMethod]
        public static List<student> ShowStudents()
        {
            return students; 
        }

        [WebMethod]
        public static void AddStudent(int id, string name, int age)
        {
            students.Add(new student { ID = id, Name = name, Age = age });
        }

        [WebMethod]
        public static void DeleteStudent(int id)
        {
            student deletedStudent = students.Find(x => x.ID == id);

            if (deletedStudent != null)
            { students.Remove(deletedStudent); }

        }

        [WebMethod]
        public static student FindUpdateStudent(int id)
        {
           return students.Find(x => x.ID == id);
        }

        [WebMethod]
        public static bool UpdateStudent(int id, string name, int age)
        {
            student UpdatedStudent = students.Find(x => x.ID == id);

            if (UpdatedStudent != null)
            {
                UpdatedStudent.Name = name;
                UpdatedStudent.Age = age;
                return true;
            }

            else
                return false;
        }
    }
}
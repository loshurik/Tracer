using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Xml;

namespace TracerWinForms
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnOpen_Click(object sender, EventArgs e)
        {
            try
            {
                openFileDialog1.Filter = "xml|*.xml";
                openFileDialog1.FileName = "";
                openFileDialog1.InitialDirectory = InitialDirectory();
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                    foreach (string s in Reader.LoadXml(openFileDialog1.FileName))
                        treeView1.Nodes.Add(s);
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            
        }

        private string InitialDirectory()
        {
            string CurrentDirectory = Directory.GetCurrentDirectory();
            DirectoryInfo InitInfo = Directory.GetParent(CurrentDirectory);
            InitInfo = Directory.GetParent(InitInfo.FullName);
            InitInfo = Directory.GetParent(InitInfo.FullName);
            return InitInfo.FullName + "\\ConsoleApplication1\\bin\\Debug";
        }
    }
}

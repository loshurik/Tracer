using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace TracerWinForms
{
    static class Reader
    {
        public static string[] LoadXml(string filename)
        {
            List<string> abc = new List<string>();
            XmlTextReader reader = new XmlTextReader(filename);
            while (reader.Read())
            {
                switch (reader.NodeType)
                {
                    case XmlNodeType.Element: // Узел является элементом.
                        abc.Add("<" + reader.Name + ">");
                        break;
                    case XmlNodeType.Text: // Вывести текст в каждом элементе.
                        abc.Add(reader.Value);
                        break;
                    case XmlNodeType.EndElement: // Вывести конец элемента.
                        abc.Add("<" + reader.Name + ">");
                        break;

                }
            }
            return abc.ToArray();
        }
    }
}

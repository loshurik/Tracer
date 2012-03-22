using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;


namespace Tracer
{
    public static class Writer
    {
        public static void ToConsole(ProfInfo source)
        {
            foreach (ProfInfo v in source.FetchValues())
                Console.WriteLine(v.ToString());
        }

        public static void ToXml(ProfInfo source, string filename)
        {
            using (XmlWriter writer = XmlWriter.Create(filename, Settings()))
            {
                writer.WriteStartDocument();
                writer.WriteStartElement("Tracing");
                while (source != null)
                {
                    WriteElement(writer, source);
                    source = source.Next;
                }
                writer.WriteEndElement();
                writer.WriteEndDocument();
                writer.Flush();
            }
        }

        private static XmlWriterSettings Settings()
        {
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Encoding = Encoding.Unicode;
            settings.Indent = true;
            settings.IndentChars = "\t";
            settings.NewLineChars = "\r\n";
            settings.NewLineOnAttributes = true;
            settings.NewLineHandling = NewLineHandling.Entitize;
            settings.OmitXmlDeclaration = false;
            return settings;
        }

        private static void WriteElement(XmlWriter writer, ProfInfo PInfo)
        {
            writer.WriteStartElement("call");
            writer.WriteElementString("Module", PInfo.Module);
            writer.WriteElementString("Class", PInfo.Class);
            writer.WriteElementString("Method", PInfo.Method);
            writer.WriteElementString("Time", PInfo.Time.ElapsedMilliseconds.ToString());
            if (PInfo.Inner != null)
            {
                writer.WriteStartElement("nested");
                WriteElement(writer, PInfo.Inner);
                writer.WriteEndElement();
            }
            writer.WriteEndElement();
        }
    }
}

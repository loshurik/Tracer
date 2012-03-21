using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Xml;
using System.IO;
using System.Diagnostics;
using Tracer;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            Stopwatch sw = new Stopwatch();
            sw.Start();
            Tracerco.Start();
            Tracerco.BeginTrace();
            DoSmth();
            Tracerco.EndTrace();
            Tracerco.BeginTrace();
            DoAnyTh();
            Thread.Sleep(300);
            Tracerco.EndTrace();
            ProfInfo PI = Tracerco.End();
            sw.Stop();
            Console.WriteLine(sw.ElapsedMilliseconds);
            Writer.ToConsole(PI);
            Writer.ToXml(PI, "res.xml");
        }

        static void DoSmth()
        {
            Tracerco.BeginTrace();
            DoSmthElse();
            Thread.Sleep(200);
            Tracerco.EndTrace();
        }
        static void DoSmthElse()
        {
            Tracerco.BeginTrace();
            Thread.Sleep(50);
            Tracerco.EndTrace();
        }
        static void DoAnyTh()
        {
            Tracerco.BeginTrace();
            Thread.Sleep(700);
            Tracerco.EndTrace();
        }
    }
}

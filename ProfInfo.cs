using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace Tracer
{
    public class ProfInfo
    {
        public Stopwatch Time { get; set; }
        public string Method { get; set; }
        public string Class { get; set; }
        public string Module { get; set; }
        public int NestingLevel { get; set; }
        public ProfInfo Next { get; set; }
        public ProfInfo Inner { get; set; }

        public ProfInfo()
        {
            Time = new Stopwatch();
        }

        public void AddNext(ProfInfo NewPInfo)
        {
            if (this.Next != null)
                this.Next.AddNext(NewPInfo);
            else
                this.Next = NewPInfo;
        }

        public void AddInner(ProfInfo NewPInfo)
        {
            if (this.Inner != null)
                this.Inner.AddInner(NewPInfo);
            else
                this.Inner = NewPInfo;
        }

        public IEnumerable<ProfInfo> FetchValues()
        {
            foreach (ProfInfo v in FetchValues(this))
                yield return v;
        }

        private IEnumerable<ProfInfo> FetchValues(ProfInfo Root)
        {
            if (Root != null)
            {
                yield return Root;
                foreach (ProfInfo v in FetchValues(Root.Inner))
                    yield return v;
                foreach (ProfInfo v in (FetchValues(Root.Next)))
                    yield return v;

            }
        }

        public override string ToString()
        {
            string s = "";
            for (int i = 0; i < NestingLevel; ++i)
                s += "\t";
            return string.Format("{4}module: {0}\n{4}class: {1}\n{4}method: {2}\n{4}time: {3}\n", Module, Class, Method, Time.ElapsedMilliseconds, s);
        }
    }
}

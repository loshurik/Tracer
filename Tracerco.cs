using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Threading;

namespace Tracer
{
    public static class Tracerco
    {
        static private bool IsActive;
        static private int NestingLevel;
        //static private Stack<ProfInfo> Added;
        //static private ProfInfo RootPInfo;
        static public ProfInfo Result;
        static private object sync = new Object();
        static private Dictionary<long, ProfInfo> RootPInfo;
        static private Dictionary<long, Stack<ProfInfo>> Added;

        static Tracerco()
        {
                long key = Thread.CurrentThread.ManagedThreadId;
                Added.Add(key, new Stack<ProfInfo>());
                //Added = new Stack<ProfInfo>();
            
        }

        static public void Start()
        {
            lock (sync)
            {
                IsActive = true;
                NestingLevel = -1;
            }
        }

        static public void BeginTrace()
        {
            lock (sync)
            {
                if (IsActive)
                {
                    // ValidateTimeBeforeInsert(ref RootPInfo, ref Added);
                    NestingLevel++;
                    StackFrame SF = new StackFrame(1);
                    ProfInfo PInfo = new ProfInfo();
                    PInfo.Method = SF.GetMethod().Name;
                    PInfo.Class = SF.GetMethod().DeclaringType.Name;
                    PInfo.Module = SF.GetMethod().Module.Name;
                    PInfo.NestingLevel = NestingLevel;
                    PInfo.Time.Start();
                    if (RootPInfo == null)
                    {
                        RootPInfo = PInfo;
                        Added.Push(RootPInfo);
                        // ValidateTimeAfterInsert(ref RootPInfo);
                        return;
                    }
                    if (Added.Count == 0)
                    {
                        RootPInfo.AddNext(PInfo);
                        Added.Push(RootPInfo);
                        //  ValidateTimeAfterInsert(ref RootPInfo);
                        return;
                    }
                    if (Added.Peek().Inner == null)
                    {
                        RootPInfo.AddInner(PInfo);
                    }
                    else
                    {
                        RootPInfo.AddNext(PInfo);
                    }
                    Added.Push(PInfo);
                    // ValidateTimeAfterInsert(ref RootPInfo,ref Added);
                }
            }
        }

        static public void EndTrace()
        {
            lock (sync)
            {
                if (IsActive)
                {
                    NestingLevel--;
                    Added.Peek().Time.Stop();
                    Added.Pop();
                }
            }
        }
        
        static public ProfInfo End()
        {
            lock (sync)
            {
                if (IsActive)
                {
                    IsActive = false;
                    return RootPInfo;
                }
                return null;
            }
        }

        static private void ValidateTimeBeforeInsert(ref ProfInfo Root, ref Stack<ProfInfo> Added)
        {
            if (Root != null)
                foreach (ProfInfo v in Root.FetchValues())
                    if (Added != null & Added.Contains(v))
                        v.Time.Stop();
        }

        static private void ValidateTimeAfterInsert(ref ProfInfo Root, ref Stack<ProfInfo> Added)
        {
            if (Root != null)
                foreach (ProfInfo v in Root.FetchValues())
                    if (Added!=null & Added.Contains(v))
                        v.Time.Start();
        }
    }

}

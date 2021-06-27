using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class OpenMailer 
{
    /// <summary>
    /// ネイティブプラグイン定義
    /// </summary>
#if UNITY_IPHONE
        [DllImport("__Internal")]
        private static extern void postMail(string to, string subject, string message);
#endif

    public void OpenMailerBase(string Address,string Kenmei, string Message)
    {
#if UNITY_IOS
            postMail(Address, Kenmei, Message);
#else
        string kenmeiOff = System.Uri.EscapeDataString(Kenmei);
        string messageOff = System.Uri.EscapeDataString(Message);
        string Url = $"mailto:{Address}?subject={kenmeiOff}&body={messageOff}";
        Application.OpenURL(Url);
#endif

    }
}

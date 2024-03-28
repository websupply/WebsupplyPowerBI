using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using WSComuns;

namespace PowerBI
{
    public class Mod_Gerais
    {

        public static string ConnectionString()
        {
            AssemblySettings settings = new AssemblySettings();
#if DEBUG
            //return settings["appConexaoRelat"].ToString();
            //return "Data Source=WEBSQLPROD02\\SGISQL02,1433;Initial Catalog=WEBSUPPLY3;User ID=bcpweb;Password=bcp2web;";
            return "Data Source=WEBSQLHOM02\\SGISQL02,1433;Initial Catalog=websupply3;User ID=websupply3;Password=Treina&Homologa@2017;";
#else
            return settings["appConexaoRelat"].ToString();
#endif
        }

        public static string retornaConteudoSoap(object objSerializer)
        {
            string strSOAP;
            MemoryStream MemStream;
            StreamWriter TextoWriter;
            System.Text.StringBuilder StrBuilder;
            System.Xml.Serialization.XmlSerializer Serializer;
            StreamReader strReader;
            try
            {
                MemStream = new MemoryStream();
                TextoWriter = new StreamWriter(MemStream, System.Text.Encoding.UTF8);
                StrBuilder = new System.Text.StringBuilder();
                Serializer = new System.Xml.Serialization.XmlSerializer(objSerializer.GetType());
                Serializer.Serialize(TextoWriter, objSerializer);
                MemStream.Position = 0;
                strReader = new StreamReader(MemStream);
                StrBuilder.Append(strReader.ReadToEnd());
                strSOAP = StrBuilder.ToString();
                StrBuilder = null;
                strReader = null;
                Serializer = null;
                TextoWriter = null;
                MemStream = null;
            }
            catch (Exception)
            {
                strSOAP = "";
            }
            return strSOAP;
        }

        public static string TrataNullTiraEspaco(object objValor)
        {
            string objRecebe = string.Empty;
            if (objValor != System.DBNull.Value)
            {
                try
                {
                    objRecebe = (string)objValor.ToString().Trim();
                }
                catch (Exception)
                {
                    objRecebe = (string)objValor;
                }
            }
            return objRecebe;
        }

  
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PowerBI.Filters;
using Newtonsoft.Json;
using System.Data;
using System.Collections;
using WSComuns;
using SgiConnection;
using System.Web;
using System.Threading;
using System.Reflection;
using System.Web.Mvc;

namespace PowerBI.Controllers
{
    [BasicAuthentication]
    public class TabelaController : ApiController
    {
        private ArrayList _ArrOut;
        private ArrayList _ArrParam;
        public string strErroRetorno;

        public string Get()
        {
            return "Informe o nome da tabela";
        }

        public object Get(string id)
        {
            Conexao _Conn = new Conexao(Mod_Gerais.ConnectionString());

            try
            {
                _ArrParam = new ArrayList();
                _ArrParam.Add(new Parametro("@iID_ACESSO", Int32.Parse(Thread.CurrentPrincipal.Identity.Name), SqlDbType.Int, 4, ParameterDirection.Input));
                _ArrParam.Add(new Parametro("@cTABELA", Mod_Gerais.TrataNullTiraEspaco(id), SqlDbType.VarChar, 100, ParameterDirection.Input));
                _ArrOut = new ArrayList();
                DataTable _dtRetorno = _Conn.ExecuteStoredProcedure(new StoredProcedure("SP_POWERBI_TABELA_SEL", _ArrParam), ref _ArrOut).Tables[0];
                return _dtRetorno;
                
            }
            catch (Exception ex)
            {
                strErroRetorno = ex.Message.ToString();
                return null;
            }
            finally
            {
                if (_Conn != null)
                {
                    _Conn.Dispose();
                    _Conn = null;
                }
            }
        }


    }
}

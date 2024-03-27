using System;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Web.Http.Filters;
using System.Web.Http.Controllers;
using WSComuns;
using SgiConnection;
using System.Data;
using System.Collections;

namespace PowerBI.Filters
{
    public class BasicAuthenticationAttribute : AuthorizationFilterAttribute
    {
        private ArrayList _ArrOut;
        private ArrayList _ArrParam;

        public override void OnAuthorization(HttpActionContext actionContext)
        {
            var authHeader = actionContext.Request.Headers.Authorization;

            if (authHeader != null)
            {
                var authenticationToken = actionContext.Request.Headers.Authorization.Parameter;
                var decodedAuthenticationToken = Encoding.UTF8.GetString(Convert.FromBase64String(authenticationToken));
                var usernamePasswordArray = decodedAuthenticationToken.Split(':');
                var userName = usernamePasswordArray[0];
                var password = usernamePasswordArray[1];
                var isValid = false;

                Conexao _Conn = new Conexao(Mod_Gerais.ConnectionString());

                try
                {
                    _ArrParam = new ArrayList();
                    _ArrParam.Add(new Parametro("@cLOGIN", Mod_Gerais.TrataNullTiraEspaco(userName), SqlDbType.VarChar, 50, ParameterDirection.Input));
                    _ArrParam.Add(new Parametro("@cSENHA", Mod_Gerais.TrataNullTiraEspaco(password), SqlDbType.VarChar, 50, ParameterDirection.Input));
                    _ArrOut = new ArrayList();
                    DataTable _dtUser = _Conn.ExecuteStoredProcedure(new StoredProcedure("SP_POWERBI_ACESSO_SEL", _ArrParam), ref _ArrOut).Tables[0];

                    if (_dtUser.Rows.Count > 0)
                    {
                        isValid = true;
                        //User.ID_ACESSO = Int32.Parse(_dtUser.Rows[0]["ID_ACESSO"].ToString());

                        var ID_ACESSO = new GenericPrincipal(new GenericIdentity(_dtUser.Rows[0]["ID_ACESSO"].ToString()), null);
                        Thread.CurrentPrincipal = ID_ACESSO;

                        return;
                    }


                }
                catch (Exception ex)
                {
                    
                }
                finally
                {
                    if (_Conn != null)
                    {
                        _Conn.Dispose();
                        _Conn = null;
                    }
                }


                if (isValid)
                {
                    var principal = new GenericPrincipal(new GenericIdentity(userName), null);
                    Thread.CurrentPrincipal = principal;

                    return;
                }
            }

            HandleUnathorized(actionContext);
        }

        private static void HandleUnathorized(HttpActionContext actionContext)
        {
            actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            actionContext.Response.Headers.Add("WWW-Authenticate", "Basic Scheme='Data' location = 'http://localhost:");
        }

    
    }
    
}

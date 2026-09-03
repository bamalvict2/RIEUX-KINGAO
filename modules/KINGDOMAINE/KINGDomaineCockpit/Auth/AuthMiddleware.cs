public class AuthMiddleware
{
    private readonly RequestDelegate _next;

    public AuthMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task Invoke(HttpContext context)
    {
        var path = context.Request.Path.Value.ToLower();

        if (!path.Contains("/login") &&
            !context.User.Identity.IsAuthenticated)
        {
            context.Response.Redirect("/Login");
            return;
        }

        await _next(context);
    }
}

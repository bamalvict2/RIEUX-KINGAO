public class AuthService
{
    private readonly List<User> _users;

    public AuthService(IWebHostEnvironment env)
    {
        var path = Path.Combine(env.ContentRootPath, "Auth", "Users.json");
        var json = File.ReadAllText(path);
        _users = JsonSerializer.Deserialize<List<User>>(json);
    }

    public User Validate(string username, string password)
    {
        return _users.FirstOrDefault(u =>
            u.Username == username &&
            u.Password == password);
    }
}

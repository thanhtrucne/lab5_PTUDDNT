using Microsoft.EntityFrameworkCore;
using TodoBackend.Models;

namespace TodoBackend.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users { get; set; }
    public DbSet<TodoItem> Todos { get; set; }
    public DbSet<ChecklistItem> ChecklistItems { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<TodoItem>()
            .HasOne(t => t.User)
            .WithMany(u => u.Todos)
            .HasForeignKey(t => t.UserId);

        modelBuilder.Entity<ChecklistItem>()
            .HasOne(c => c.TodoItem)
            .WithMany(t => t.ChecklistItems)
            .HasForeignKey(c => c.TodoItemId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

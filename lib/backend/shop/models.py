from django.db import models

class Product(models.Model):
    CATEGORY_CHOICES = (
        ('men', "Men's Wear"),
        ('women', "Women's Wear"),
        ('shoes', "Shoes"),
    )
    name = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=8, decimal_places=2)
    discounted_price = models.DecimalField(max_digits=8, decimal_places=2, null=True, blank=True)
    image_url = models.CharField(max_length=500, default='', blank=True)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='men')
    available_sizes = models.CharField(max_length=255)  # Например: "S,M,L,XL"
    available_stores = models.CharField(max_length=255) # Например: "Main Store,Online"

    def __str__(self):
        return self.name

class Review(models.Model):
    product = models.ForeignKey(Product, related_name='reviews', on_delete=models.CASCADE)
    author = models.CharField(max_length=255)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Review by {self.author} for {self.product.name}"

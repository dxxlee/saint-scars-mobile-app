# backend/shop/urls_register.py

from django.urls import path
from .views import RegisterView

urlpatterns = [
    path('', RegisterView.as_view(), name='register'),
]

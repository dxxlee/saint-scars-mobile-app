from django.contrib.auth import authenticate, get_user_model
from rest_framework import viewsets
from rest_framework import status, generics
from rest_framework.authtoken.models import Token
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import RegisterSerializer
from django.contrib.auth.models import User



from .models import Product, Review
from .serializers import ProductSerializer, ReviewSerializer, UserSerializer

User = get_user_model()

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all().order_by("id")
    serializer_class = ProductSerializer
    permission_classes = []  # по необходимости

class ReviewViewSet(viewsets.ModelViewSet):
    queryset = Review.objects.all().order_by("-created_at")
    serializer_class = ReviewSerializer
    permission_classes = []  # по необходимости

class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        # Ожидаем поля: username, email, password
        username = request.data.get("username", "").strip()
        email = request.data.get("email", "").strip()
        password = request.data.get("password", "")

        if not username or not email or not password:
            return Response(
                {"detail": "Username, email and password are required."},
                status=400,
            )

        if User.objects.filter(username__iexact=username).exists():
            return Response({"detail": "Username already exists."}, status=400)
        if User.objects.filter(email__iexact=email).exists():
            return Response({"detail": "Email already registered."}, status=400)

        user = User.objects.create_user(username=username, email=email, password=password)
        token, _ = Token.objects.get_or_create(user=user)
        return Response({"token": token.key}, status=201)

class LoginByEmailView(generics.GenericAPIView):
    """
    POST /api/login/
    {
      "email": "...",
      "password": "..."
    }
    """
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')
        if not email or not password:
            return Response({'detail':'Email and password required'},
                            status=status.HTTP_400_BAD_REQUEST)
        # Сначала ищем пользователя по e‑mail
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'detail':'Invalid credentials'},
                            status=status.HTTP_400_BAD_REQUEST)

        # Теперь аутентифицируем именно по username
        user = authenticate(request,
                            username=user.username,
                            password=password)
        if user is None:
            return Response({'detail':'Invalid credentials'},
                            status=status.HTTP_400_BAD_REQUEST)

        # Всё ок, возвращаем токен + данные пользователя
        token, _ = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user': {
                'id': user.id,
                'username': user.username,
                'email': user.email,
            }
        })

class ProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)
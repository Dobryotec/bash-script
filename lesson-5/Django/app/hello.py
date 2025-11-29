
from django.http import HttpResponse
from django.utils import timezone

def hello_world(request):
    return HttpResponse(f"""
    <h1>Final Project — Django Running!</h1>
    <p>Deployed via Jenkins + ArgoCD</p>
    <p>Time: {timezone.now()}</p>
    <p>Everything works perfectly!</p>
    """, content_type="text/html")
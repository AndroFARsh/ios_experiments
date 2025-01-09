from django.views.generic import TemplateView
from django.core.exceptions import ValidationError
from django.core.validators import EmailValidator
from django.contrib.auth import get_user_model
from django.http.response import JsonResponse

from rest_framework.response import Response
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny
from rest_framework import status

from . import utils

USER_MODEL = get_user_model()

class RegisterAppUser(GenericAPIView):

    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get('email', None)
        password = request.data.get('password', None)
        confirm_password = request.data.get('confirm_password', None)

        if email is None:
            return Response('Missing Email', status=status.HTTP_400_BAD_REQUEST)
        if password is None:
            return Response('Missing Password', status=status.HTTP_400_BAD_REQUEST)
        if confirm_password is None:
            return Response('Missing Password Confirm', status=status.HTTP_400_BAD_REQUEST)
        
        data_validation_errors = []
        if password != confirm_password:
            data_validation_errors.append("Password fields don't match")
        try:
            validator = EmailValidator()
            validator(email)
        except ValidationError as e:
            print(e)
            data_validation_errors.append(e.message)

        if len(data_validation_errors) > 0:
            return Response(data_validation_errors, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            user = USER_MODEL.objects.create_user(
                username=email, 
                email=email, 
                password=password, 
                is_active=False,
            )
        except Exception as e: 
            print(e)
            return Response(f'User {email} already exist', status=status.HTTP_409_CONFLICT)
        
        success = utils.send_activation_email(user)

        if not success:
            return Response('Could not sent email', status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        return Response(f'Success. An activation email has been sent to: {email}', status=status.HTTP_201_CREATED)

class ActivateAppUser(TemplateView):
    
    template_name = 'api/account_activation.html'
    

    def get(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        token = kwargs.get('token', None)
        if token is None or not utils.is_token_valid(token):
            context['failed_reason'] = 'Token Invalid'
            return self.render_to_response(context)
        
        try:
            user = utils.get_user_from_tocken(token)
            utils.revoke_tocken(token)
        except ValidationError as e:
            context['failed_reason'] = e.message
            return self.render_to_response(context)
        
        user.is_active = True
        user.save()

        return self.render_to_response(context)



class LoginDataApi(GenericAPIView):

    def post(self, request): 
        data = {
            'message': 'You are logged in! [POST]'
        }
        return JsonResponse(data, safe=False, status=status.HTTP_200_OK)

    def get(self, request): 
        data = {
            'message': 'You are logged in! [GET]'
        }
        return JsonResponse(data, safe=False, status=status.HTTP_200_OK)

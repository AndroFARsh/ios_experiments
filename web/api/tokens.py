from rest_framework_simplejwt.tokens import BlacklistMixin, AccessToken

class BlacklistableAccessTocken(AccessToken, BlacklistMixin):
    pass
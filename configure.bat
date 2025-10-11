CALL git submodule update --init --recursive
CALL fvm flutter clean
@REM IF NOT EXIST .env CALL copy /d .env.dev.android .env
@REM CALL sync_locale.bat
CALL fvm flutter pub get
CALL fvm dart run build_runner build --delete-conflicting-outputs
@REM CALL flutter test --coverage
# =====================================================================
#  Netlify 원클릭 키트 - 시작하기 (한국어 안내판)
#  비개발자용: 지금 무엇을 눌러야 하는지 한 줄로 알려줍니다.
#  (영어 INSTALL/RUN/UNINSTALL.bat 엔진을 한국어로 안내만 합니다.)
# =====================================================================

$ErrorActionPreference = 'SilentlyContinue'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$LibDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root   = Split-Path -Parent $LibDir
Set-Location $Root

# 다운로드 차단(Mark of the Web) 자동 해제 - 받은 파일이 윈도우에 막히지 않게
try { Get-ChildItem -LiteralPath $Root -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue } catch {}

function Has-Command([string]$name) {
    $c = Get-Command $name -ErrorAction SilentlyContinue
    return [bool]$c
}

function Get-NfVersion {
    if (-not (Has-Command 'netlify')) { return $null }
    $v = (& netlify --version 2>$null | Select-Object -First 1)
    return $v
}

# 로그인 여부는 설정 파일로 빠르게(오프라인) 판단합니다. (정확한 확인은 '로그인 상태 확인' 메뉴)
# Netlify 설정 위치: %APPDATA%\netlify\Config\config.json
#   - 로그인되면 userId 와 users.<id>.auth.token 이 채워집니다.
function Is-LoggedIn {
    $cfg = Join-Path $env:APPDATA 'netlify\Config\config.json'
    if (-not (Test-Path $cfg)) { return $false }
    $txt = Get-Content -LiteralPath $cfg -Raw -ErrorAction SilentlyContinue
    if (-not $txt) { return $false }
    try {
        $o = $txt | ConvertFrom-Json
        if ($o.userId -and $o.users) {
            $u = $o.users.($o.userId)
            if ($u -and $u.auth -and $u.auth.token) { return $true }
        }
        return $false
    } catch {
        if (($txt -match '"userId"\s*:\s*"[^"]+"') -and ($txt -match '"token"\s*:\s*"[^"]+"')) { return $true }
        return $false
    }
}

function Pause-Key {
    Write-Host ''
    Write-Host '  계속하려면 아무 키나 누르세요...' -ForegroundColor DarkGray
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

# ---------------------------------------------------------------------
#  공용 메뉴: 위/아래 화살표로 고르고 Enter, 또는 번호키.
#  화살표 입력을 못 받는 환경이면 자동으로 '번호 입력' 방식으로 폴백.
#   - $Title       : 제목 한 줄
#   - $StatusLines : @{ Text; Color(선택); Back(선택) } 배열 (상태/안내 줄)
#   - $Items       : @{ Key; Text; Color; Mark } 배열
#   - $RecKey      : 처음 커서를 올려둘(추천) 항목 Key
# ---------------------------------------------------------------------
function Show-Menu {
    param([string]$Title, [array]$StatusLines, [array]$Items, [string]$RecKey = '1')
    $idx = 0
    for ($i = 0; $i -lt $Items.Count; $i++) { if ($Items[$i].Key -eq $RecKey) { $idx = $i; break } }

    while ($true) {
        Clear-Host
        Write-Host ''
        Write-Host '  ============================================' -ForegroundColor Cyan
        Write-Host ("     {0}" -f $Title) -ForegroundColor Cyan
        Write-Host '  ============================================' -ForegroundColor Cyan
        foreach ($s in $StatusLines) {
            if     ($s.Back)  { Write-Host $s.Text -ForegroundColor $s.Color -BackgroundColor $s.Back }
            elseif ($s.Color) { Write-Host $s.Text -ForegroundColor $s.Color }
            else              { Write-Host $s.Text }
        }
        Write-Host ''
        Write-Host '   고르는 법: 위/아래 화살표 + Enter,  또는 번호키(1~9)' -ForegroundColor DarkCyan
        Write-Host '   빠른 길: 그냥 Enter = 초록색 추천 항목 실행.    ESC = 취소/뒤로' -ForegroundColor DarkCyan
        Write-Host '  --------------------------------------------' -ForegroundColor DarkCyan
        Write-Host ''
        for ($i = 0; $i -lt $Items.Count; $i++) {
            $it = $Items[$i]
            $sel = ($i -eq $idx)
            $bullet = if ($sel) { ' > ' } else { '   ' }
            $line = ("{0}[{1}] {2}{3}" -f $bullet, $it.Key, $it.Text, $it.Mark)
            if ($sel) { Write-Host $line -ForegroundColor Black -BackgroundColor $it.Color }
            else      { Write-Host $line -ForegroundColor $it.Color }
        }
        Write-Host ''
        # 선택 도우미: 지금 커서가 놓인 항목이 무슨 일을 하는지 한 줄로 미리 보여줌 (정확/안전한 선택)
        if ($Items[$idx].Help) {
            $hc = if ($Items[$idx].Color -eq 'Red') { 'Yellow' } else { 'Gray' }
            Write-Host ('   >> 지금 고른 항목: ' + $Items[$idx].Help) -ForegroundColor $hc
            Write-Host ''
        }

        try {
            $k = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        } catch {
            $typed = Read-Host '   번호를 입력하고 Enter'
            if ($null -eq $typed) { $typed = '' }
            $m = $Items | Where-Object { $_.Key -eq $typed.Trim() }
            if ($m) { return $m.Key } else { continue }
        }

        $vk = $k.VirtualKeyCode
        if     ($vk -eq 38) { $idx--; if ($idx -lt 0) { $idx = $Items.Count - 1 } }   # 위 화살표
        elseif ($vk -eq 40) { $idx++; if ($idx -ge $Items.Count) { $idx = 0 } }       # 아래 화살표
        elseif ($vk -eq 13) { return $Items[$idx].Key }                               # Enter
        elseif ($vk -eq 27) { return '0' }                                            # ESC = 취소/뒤로 (모든 메뉴에서 0번이 안전한 빠져나가기)
        else {
            $ch = ("{0}" -f $k.Character).Trim()
            if ($ch -ne '') {
                $m = $Items | Where-Object { $_.Key -eq $ch }
                if ($m) { return $m.Key }
            }
        }
    }
}

# ---------------------------------------------------------------------
#  [2] 사용하기 -> 한국어 '자주 쓰는 작업' 메뉴
#   - 가장 흔하고 안전한 작업(로그인/상태/사이트목록)은 여기서 한국어로 바로 실행
#   - 배포/사이트 만들기 등 폴더에 따라 달라지는 작업은 '전체 메뉴(RUN.bat)'로 안전 위임
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
#  안전한 배포: 폴더가 웹사이트인지 먼저 확인 + 미리보기/진짜공개 분리 + YES 게이트
#  (배포는 되돌릴 수 없는 '공개'라, 엉뚱한 폴더 공개를 막는 것이 핵심)
# ---------------------------------------------------------------------
function Invoke-Deploy {
    param([string]$PresetTarget = '')
    if (-not (Is-LoggedIn)) {
        Write-Host ''
        Write-Host '  배포하려면 먼저 로그인이 필요해요. [1] 로그인 부터 해주세요.' -ForegroundColor Yellow
        Pause-Key; return
    }

    # 1) 배포할 폴더 정하기 - 웹사이트 파일이 있는지 확인 (이 키트 폴더엔 보통 없음)
    $target = $Root
    if ($PresetTarget -ne '') { $target = $PresetTarget }   # 연습 배포 등: 폴더를 미리 지정 (폴더 묻기 생략)
    $marks = @('index.html','netlify.toml','package.json','_site','dist','public','build')
    $looksWeb = $false
    foreach ($m in $marks) { if (Test-Path (Join-Path $target $m)) { $looksWeb = $true; break } }

    if (($PresetTarget -eq '') -and (-not $looksWeb)) {
        Write-Host ''
        Write-Host '  [확인] 지금 폴더에는 웹사이트 파일이 안 보입니다.' -ForegroundColor Yellow
        Write-Host ('         폴더: {0}' -f $target) -ForegroundColor DarkGray
        Write-Host '  배포는 "내 웹사이트 파일이 있는 폴더"에서 해야 합니다.' -ForegroundColor Yellow
        Write-Host ''
        Write-Host '  웹사이트 폴더를 끌어다 놓거나 경로를 붙여넣고 Enter.' -ForegroundColor Gray
        Write-Host '  (그냥 Enter 치면 취소합니다.)' -ForegroundColor Gray
        $p = Read-Host '  웹사이트 폴더 경로'
        if ($null -eq $p) { $p = '' }
        $p = $p.Trim().Trim('"')
        if ($p -eq '') { Write-Host '  배포를 취소했습니다.' -ForegroundColor Gray; Pause-Key; return }
        if (-not (Test-Path $p)) { Write-Host '  그 폴더를 찾을 수 없어요. 경로를 다시 확인해주세요.' -ForegroundColor Yellow; Pause-Key; return }
        $target = $p
    }

    # 2) 미리보기 vs 진짜 공개 선택
    $dStatus = @(
        @{ Text = '' },
        @{ Text = ('  배포할 폴더: {0}' -f $target); Color = 'DarkCyan' },
        @{ Text = '' }
    )
    $dItems = @(
        @{ Key = '1'; Text = '미리보기 배포   (임시 주소, 진짜 사이트는 그대로 - 안전)'; Color = 'Green';    Mark = '   <- 추천'; Help = '임시 주소로만 올려 나 혼자 확인합니다. 진짜 사이트는 안 바뀌어 안전합니다. 연습은 항상 이것!' },
        @{ Key = '2'; Text = '진짜 공개 배포  (방문자가 바로 보게 됨 - 주의)';           Color = 'Red';      Mark = ''; Help = '주의! 누구나 볼 수 있게 진짜로 공개합니다. 확실할 때만, 대문자 YES 를 입력해야 진행됩니다.' },
        @{ Key = '0'; Text = '취소'; Color = 'DarkGray'; Mark = ''; Help = '배포를 하지 않고 돌아갑니다.' }
    )
    $d = Show-Menu -Title 'Netlify - 인터넷에 올리기 (배포)' -StatusLines $dStatus -Items $dItems -RecKey '1'
    if ($null -eq $d) { $d = '' }

    switch ($d.Trim()) {
        '1' {
            Write-Host ''
            Write-Host '  미리보기로 올립니다. 임시 주소(Draft URL)가 나오면 그 주소로 확인하세요.' -ForegroundColor Gray
            Write-Host ''
            Push-Location $target
            & netlify deploy
            Pop-Location
            Pause-Key
        }
        '2' {
            Write-Host ''
            Write-Host '  *** 주의: 진짜 공개 배포 ***' -ForegroundColor Red
            Write-Host '  지금 폴더의 내용이 인터넷에 공개되어 방문자가 바로 보게 됩니다.' -ForegroundColor Yellow
            Write-Host ('  폴더: {0}' -f $target) -ForegroundColor DarkGray
            Write-Host ''
            $yes = Read-Host '  정말 공개하려면 대문자로 YES 를 입력하세요'
            if ($yes -cne 'YES') { Write-Host '  취소했습니다. (YES 가 아니라서 진행하지 않음)' -ForegroundColor Gray; Pause-Key; return }
            Write-Host ''
            Write-Host '  진짜 공개 배포를 진행합니다...' -ForegroundColor Yellow
            Push-Location $target
            & netlify deploy --prod
            Pop-Location
            Pause-Key
        }
        default { return }
    }
}

# ---------------------------------------------------------------------
#  연습용 샘플 사이트로 배포 체험
#  - 가진 웹사이트가 없어도 '설치->로그인->배포->실제 주소' 성공 한 바퀴를 경험
#  - 기존 Invoke-Deploy 를 그대로 재사용(폴더만 sample-site 로 지정)
# ---------------------------------------------------------------------
function Invoke-PracticeDeploy {
    if (-not (Is-LoggedIn)) {
        Write-Host ''
        Write-Host '  체험 배포도 로그인이 필요해요. 먼저 [1] 로그인 부터 해주세요.' -ForegroundColor Yellow
        Pause-Key; return
    }
    $sample = Join-Path $Root 'sample-site'
    if (-not (Test-Path (Join-Path $sample 'index.html'))) {
        Write-Host ''
        Write-Host '  연습용 샘플 사이트(sample-site 폴더)를 찾지 못했어요.' -ForegroundColor Yellow
        Write-Host '  키트를 다시 내려받으면 들어 있습니다.' -ForegroundColor Gray
        Pause-Key; return
    }
    Write-Host ''
    Write-Host '  연습용 사이트로 배포를 "체험"합니다. (키트에 들어 있는 한 장짜리 예제)' -ForegroundColor Gray
    Write-Host '  처음이면 [1] 미리보기 로 안전하게 연습하세요. 임시 주소(Draft URL)가 나옵니다.' -ForegroundColor Gray
    Invoke-Deploy -PresetTarget $sample
}

# ---------------------------------------------------------------------
#  자가 진단 - 무엇이 문제인지 한국어로 점검하고 바로 처방
#  (영어 RUN.bat 의 진단을, 한국어 처방과 함께 메인에서 바로 실행)
# ---------------------------------------------------------------------
function Invoke-SelfCheck {
    Clear-Host
    Write-Host ''
    Write-Host '  ============================================' -ForegroundColor Cyan
    Write-Host '     문제 해결 - 자가 진단' -ForegroundColor Cyan
    Write-Host '  ============================================' -ForegroundColor Cyan
    Write-Host ''

    $problems = 0

    # 1) Node.js (필수 부품)
    if (Has-Command 'node') {
        $nv = (& node --version 2>$null)
        Write-Host ('  [OK] Node.js(필수 부품) 있음  ' + $nv) -ForegroundColor Green
    } else {
        $problems++
        Write-Host '  [문제] Node.js(필수 부품)가 없습니다.' -ForegroundColor Yellow
        Write-Host '     -> https://nodejs.org 에서 LTS(숫자 20 이상) 설치 후, 시작하기.bat 다시 실행 -> [1] 설치' -ForegroundColor Gray
    }

    # 2) Netlify CLI
    if (Has-Command 'netlify') {
        $cv = Get-NfVersion
        Write-Host ('  [OK] Netlify CLI 있음  v' + $cv) -ForegroundColor Green
    } else {
        $problems++
        Write-Host '  [문제] Netlify CLI가 설치되지 않았습니다.' -ForegroundColor Yellow
        Write-Host '     -> 시작하기.bat -> [1] 설치하기. 설치 후엔 창을 모두 닫고 새 창에서 다시 여세요.' -ForegroundColor Gray
    }

    # 3) 로그인
    if (Has-Command 'netlify') {
        if (Is-LoggedIn) {
            Write-Host '  [OK] Netlify 로그인 되어 있음' -ForegroundColor Green
        } else {
            $problems++
            Write-Host '  [문제] 아직 로그인 전입니다.' -ForegroundColor Yellow
            Write-Host '     -> 계정이 없으면 https://app.netlify.com 에서 무료 가입(카드 X) 후, [2] 사용하기 -> [1] 로그인' -ForegroundColor Gray
        }
    }

    # 4) 인터넷 연결 (npm 서버 registry.npmjs.org:443, 3초 제한)
    $net = $false
    try {
        $cli = New-Object System.Net.Sockets.TcpClient
        $iar = $cli.BeginConnect('registry.npmjs.org', 443, $null, $null)
        $net = $iar.AsyncWaitHandle.WaitOne(3000, $false)
        $cli.Close()
    } catch { $net = $false }
    if ($net) {
        Write-Host '  [OK] 인터넷 연결 정상 (npm 서버에 닿음)' -ForegroundColor Green
    } else {
        $problems++
        Write-Host '  [문제] npm 서버에 연결하지 못했습니다.' -ForegroundColor Yellow
        Write-Host '     -> 와이파이 확인 / 백신 10분 끄기 / 회사망이면 개인 인터넷에서 다시 시도' -ForegroundColor Gray
    }

    Write-Host ''
    if ($problems -eq 0) {
        Write-Host '  >> 진단 결과: 문제 없음! 바로 [2] 사용하기 로 진행하면 됩니다.' -ForegroundColor White -BackgroundColor DarkGreen
    } else {
        Write-Host ('  >> 진단 결과: ' + $problems + '가지 항목을 위 안내대로 처리해 주세요.') -ForegroundColor White -BackgroundColor DarkRed
        Write-Host '     더 자세한 해결은 사용설명서.md 의 "오류가 났을 때" 표를 보세요.' -ForegroundColor Gray
    }
    Pause-Key
}

function Use-QuickActions {
    while ($true) {
        $logged = Is-LoggedIn

        $status = @()
        $status += @{ Text = '' }
        if ($logged) { $status += @{ Text = '  로그인: 되어 있음  [OK]'; Color = 'Green' } }
        else         { $status += @{ Text = '  로그인: 안 됨  (먼저 [1] 로그인)'; Color = 'Yellow' } }
        $status += @{ Text = '' }
        if ($logged) { $status += @{ Text = '  >> 준비됐어요! [4] 연습 배포 체험 부터 해보세요 (안전).'; Color = 'White'; Back = 'DarkGreen' } }
        else         { $status += @{ Text = '  >> 지금 할 일: [1] 로그인 부터 하세요.'; Color = 'White'; Back = 'DarkGreen' } }

        $recSub = if ($logged) { '4' } else { '1' }
        $cLogin = if (-not $logged) { 'Green' } else { 'Gray' }
        $cAct   = if ($logged) { 'White' } else { 'Gray' }
        $items = @(
            @{ Key = '1'; Text = '로그인              (브라우저로 Netlify 계정 연결)'; Color = $cLogin;  Mark = $(if ($recSub -eq '1') { '   <- 지금 이것!' } else { '' }); Help = '인터넷 브라우저가 열리면 Netlify 계정으로 로그인합니다. 계정이 없으면 먼저 무료 가입(app.netlify.com).' },
            @{ Key = '2'; Text = '로그인 상태 확인'; Color = 'White'; Mark = ''; Help = '지금 로그인이 잘 되어 있는지 확인만 합니다. 안전합니다.' },
            @{ Key = '3'; Text = '내 사이트 목록 보기     (로그인 필요)'; Color = 'White'; Mark = ''; Help = '내 Netlify 계정에 있는 사이트 목록을 보여줍니다. 안전합니다.' },
            @{ Key = '4'; Text = '연습용 사이트로 배포 체험 (처음이면 추천 - 안전)'; Color = $cAct; Mark = $(if ($recSub -eq '4') { '   <- 추천' } else { '' }); Help = '키트에 든 한 장짜리 예제를 올려 배포를 안전하게 연습합니다. 처음이라면 이것부터!' },
            @{ Key = '5'; Text = '인터넷에 올리기 (배포)  (내 폴더 - 미리보기/공개 안내)'; Color = $cAct; Mark = ''; Help = '내 웹사이트 폴더를 올립니다. 먼저 폴더를 확인하고, 미리보기/진짜공개를 고르게 합니다.' },
            @{ Key = '6'; Text = '전체 메뉴 열기          (사이트 만들기 등 26가지)'; Color = 'White'; Mark = ''; Help = '사이트 만들기 등 고급 기능이 있는 영어 전체 메뉴(RUN.bat) 창을 엽니다.' },
            @{ Key = '0'; Text = '뒤로'; Color = 'DarkGray'; Mark = ''; Help = '앞 화면(시작 메뉴)으로 돌아갑니다.' }
        )

        $c = Show-Menu -Title 'Netlify - 자주 쓰는 작업' -StatusLines $status -Items $items -RecKey $recSub
        if ($null -eq $c) { $c = '' }

        switch ($c.Trim()) {
            '1' {
                Write-Host ''
                Write-Host '  인터넷 브라우저가 열립니다. 거기서 로그인 / 권한 허용(Authorize) 하세요.' -ForegroundColor Gray
                Write-Host '  (브라우저에서 끝내면 이 창으로 돌아옵니다.)' -ForegroundColor Gray
                Write-Host ''
                & netlify login
                Pause-Key
            }
            '2' {
                Write-Host ''
                Write-Host '  ==== 로그인 상태 ====' -ForegroundColor Cyan
                Write-Host ''
                & netlify status
                Pause-Key
            }
            '3' {
                if (-not $logged) {
                    Write-Host ''
                    Write-Host '  아직 로그인 전이에요. 먼저 [1] 로그인 부터 해주세요.' -ForegroundColor Yellow
                    Pause-Key
                } else {
                    Write-Host ''
                    Write-Host '  ==== 내 사이트 목록 ====' -ForegroundColor Cyan
                    Write-Host ''
                    & netlify 'sites:list'
                    Pause-Key
                }
            }
            '4' {
                Invoke-PracticeDeploy
            }
            '5' {
                if (-not $logged) {
                    Write-Host ''
                    Write-Host '  배포하려면 먼저 [1] 로그인 부터 해주세요.' -ForegroundColor Yellow
                    Pause-Key
                } else {
                    Invoke-Deploy
                }
            }
            '6' {
                Start-Process -FilePath (Join-Path $Root 'RUN.bat')
                Write-Host ''
                Write-Host '  전체 메뉴(영어) 창을 열었습니다. 그 창에서 번호를 고르세요.' -ForegroundColor Gray
                Write-Host '  (새 사이트 만들기: 9 / 함수·빌드 등 고급 기능)' -ForegroundColor Gray
                Pause-Key
            }
            '0' { return }
            default {
                Write-Host ''
                Write-Host '  그 번호는 메뉴에 없어요. 0~6 중에서 골라주세요.' -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
        }
    }
}

# =====================================================================
#  메인 메뉴
# =====================================================================
$running = $true
while ($running) {
    $hasNode = Has-Command 'node'
    $hasNf   = Has-Command 'netlify'
    $nfVer   = Get-NfVersion
    $logged  = $false
    if ($hasNf) { $logged = Is-LoggedIn }

    # 상태 표시 줄
    $status = @()
    $status += @{ Text = '' }
    $status += @{ Text = '  [지금 내 컴퓨터 상태]' }
    if ($hasNode) { $status += @{ Text = '   - Node.js (필수 부품)   : 있음  [OK]'; Color = 'Green' } }
    else          { $status += @{ Text = '   - Node.js (필수 부품)   : 없음  [설치 필요]'; Color = 'Yellow' } }
    if ($hasNf)   { $status += @{ Text = ("   - Netlify CLI           : 있음 (v{0})  [OK]" -f $nfVer); Color = 'Green' } }
    else          { $status += @{ Text = '   - Netlify CLI           : 없음  [설치 필요]'; Color = 'Yellow' } }
    if ($hasNf) {
        if ($logged) { $status += @{ Text = '   - Netlify 로그인        : 되어 있음  [OK]'; Color = 'Green' } }
        else         { $status += @{ Text = '   - Netlify 로그인        : 안 됨  [로그인 필요]'; Color = 'Yellow' } }
    }
    $status += @{ Text = '' }
    # 지금 할 일 한 줄 (가장 중요)
    if (-not $hasNf) {
        $status += @{ Text = '  >> 지금 할 일: [1] 설치하기 를 누르세요.'; Color = 'White'; Back = 'DarkGreen' }
    } elseif (-not $logged) {
        $status += @{ Text = '  >> 지금 할 일: [2] 사용하기 -> 로그인 부터.'; Color = 'White'; Back = 'DarkGreen' }
    } else {
        $status += @{ Text = '  >> 준비 끝! [2] 사용하기 로 들어가면 됩니다.'; Color = 'White'; Back = 'DarkGreen' }
    }

    if (-not $hasNf) { $recKey = '1' } else { $recKey = '2' }
    $cInstall = if (-not $hasNf) { 'Green' } else { 'Gray' }
    $cUse     = if ($hasNf)      { 'Green' } else { 'Gray' }

    $items = @(
        @{ Key = '1'; Text = '설치하기      (Netlify CLI를 컴퓨터에 깔기)';   Color = $cInstall;  Mark = $(if ($recKey -eq '1') { '   <- 지금 이것!' } else { '' }); Help = 'Netlify 도구를 컴퓨터에 깝니다. 처음 한 번만 하면 됩니다. (인터넷 필요)' },
        @{ Key = '2'; Text = '사용하기      (로그인 / 사이트 / 배포)';        Color = $cUse;      Mark = $(if ($recKey -eq '2') { '   <- 지금 이것!' } else { '' }); Help = '로그인하고, 연습 배포나 내 사이트 배포를 하는 한국어 메뉴로 들어갑니다.' },
        @{ Key = '3'; Text = '문제가 생겼어요? (자가 진단 - 무엇이 문제인지 한국어로)'; Color = 'Cyan'; Mark = ''; Help = '무엇이 문제인지 자동으로 점검하고 해결법을 알려줍니다. 아무것도 바꾸지 않아 안전합니다.' },
        @{ Key = '4'; Text = '제거하기      (깨끗이 지우기, 내 코드는 안 지움)'; Color = 'Red';      Mark = '   (주의)'; Help = 'Netlify 도구만 지웁니다. 내 코드 파일은 그대로 둡니다. 지우기 전에 다시 한 번 물어봅니다.' },
        @{ Key = '5'; Text = '사용설명서    (왕초보 가이드 열기)';             Color = 'White';    Mark = ''; Help = '그림(미리보기)과 함께 따라 하는 왕초보 가이드 문서를 엽니다. 안전합니다.' },
        @{ Key = '6'; Text = 'Netlify 대시보드(내 사이트 관리) 열기';          Color = 'White';    Mark = ''; Help = '인터넷 브라우저에서 내 사이트를 관리하는 Netlify 홈페이지를 엽니다.' },
        @{ Key = '0'; Text = '끝내기';                                         Color = 'DarkGray'; Mark = ''; Help = '이 안내판을 닫습니다. 언제든 시작하기.bat 를 다시 열면 됩니다.' }
    )

    $choice = Show-Menu -Title 'Netlify 원클릭 키트 - 시작하기' -StatusLines $status -Items $items -RecKey $recKey
    if ($null -eq $choice) { $choice = '' }

    switch ($choice.Trim()) {
        '1' {
            Write-Host ''
            Write-Host '  설치 창을 엽니다. 검은 창이 영어로 떠도 놀라지 마세요 - 그대로 진행됩니다.' -ForegroundColor Gray
            Write-Host '  이제 관리자 허용 창은 뜨지 않습니다. (혹시 권한 오류가 나면 INSTALL.bat 우클릭 -> 관리자 권한으로 실행)' -ForegroundColor Gray
            if (-not $hasNode) {
                Write-Host '  Node.js(필수 부품)가 없으면, 창이 nodejs.org 에서 받는 방법을 안내합니다.' -ForegroundColor Yellow
                Write-Host '  (LTS 버전을 받아 설치한 뒤, 이 창으로 돌아와 다시 [1] 설치하기 하세요.)' -ForegroundColor Yellow
            }
            Start-Process -FilePath (Join-Path $Root 'INSTALL.bat')
            Write-Host ''
            Write-Host '  설치가 끝나면 이 창으로 돌아와 아무 키나 누르세요. 상태를 다시 확인합니다.' -ForegroundColor Gray
            Pause-Key
        }
        '2' {
            if (-not $hasNf) {
                Write-Host ''
                Write-Host '  아직 설치가 안 되어 있어요. 먼저 [1] 설치하기 부터 해주세요.' -ForegroundColor Yellow
                Pause-Key
            } else {
                Use-QuickActions
            }
        }
        '3' {
            Invoke-SelfCheck
        }
        '4' {
            Write-Host ''
            Write-Host '  제거 창을 엽니다. 정말 지울지 한 번 더 물어봅니다(YES 입력).' -ForegroundColor Gray
            Start-Process -FilePath (Join-Path $Root 'UNINSTALL.bat')
            Pause-Key
        }
        '5' {
            $guide = Join-Path $Root '사용설명서.md'
            if (Test-Path $guide) { Start-Process $guide }
            else { Start-Process (Join-Path $Root 'README.md') }
            Pause-Key
        }
        '6' {
            Start-Process 'https://app.netlify.com/'
            Pause-Key
        }
        '0' { $running = $false }
        default {
            Write-Host ''
            Write-Host '  그 번호는 메뉴에 없어요. 0~6 중에서 골라주세요.' -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
}

Clear-Host
Write-Host ''
Write-Host '  안녕히 가세요! 좋은 하루 되세요.' -ForegroundColor Cyan
Write-Host ''
Start-Sleep -Seconds 1

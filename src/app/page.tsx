'use client'

export default function Home() {
  const files = [
    { name: 'PXTikTok.dylib', desc: 'Tweak dylib (arm64 + arm64e)', size: '899 KB', icon: '📱' },
    { name: 'CydiaSubstrate.dylib', desc: 'Substrate shim (arm64 + arm64e)', size: '133 KB', icon: '🔧' },
    { name: 'PXTikTok-latest.zip', desc: 'ZIP с обоими dylib + plist', size: '298 KB', icon: '📦' },
  ]

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '100vh',
      gap: '2rem',
      padding: '2rem',
      background: 'linear-gradient(135deg, #0f0f23 0%, #1a1a3e 50%, #2d1b69 100%)',
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
    }}>
      <h1 style={{
        color: '#fff',
        fontSize: '2rem',
        fontWeight: 700,
        textAlign: 'center',
      }}>
        PXTikTok Dylib Download
      </h1>

      <p style={{ color: '#aaa', fontSize: '0.9rem', textAlign: 'center' }}>
        Mach-O universal binary — arm64 + arm64e — built 2025-07-22
      </p>

      <div style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '1rem',
        width: '100%',
        maxWidth: '400px',
      }}>
        {files.map(f => (
          <a
            key={f.name}
            href={`/api/download?file=${encodeURIComponent(f.name)}`}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '1rem',
              padding: '1rem 1.5rem',
              borderRadius: '12px',
              background: 'rgba(255,255,255,0.08)',
              border: '1px solid rgba(255,255,255,0.15)',
              color: '#fff',
              textDecoration: 'none',
              transition: 'all 0.2s',
              cursor: 'pointer',
            }}
          >
            <span style={{ fontSize: '1.5rem' }}>{f.icon}</span>
            <div style={{ flex: 1 }}>
              <div style={{ fontWeight: 600, fontSize: '1rem' }}>{f.name}</div>
              <div style={{ color: '#aaa', fontSize: '0.8rem' }}>{f.desc}</div>
            </div>
            <span style={{ color: '#888', fontSize: '0.8rem' }}>{f.size}</span>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6c6" strokeWidth="2">
              <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4M7 10l5 5 5-5M12 15V3"/>
            </svg>
          </a>
        ))}
      </div>

      <p style={{ color: '#666', fontSize: '0.75rem', textAlign: 'center', marginTop: '1rem' }}>
        PXTok v1.1 • GitHub: kreadwrite/dylib
      </p>
    </div>
  )
}

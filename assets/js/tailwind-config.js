tailwind.config = {
    theme: {
        extend: {
            fontFamily: {
                sans: ['Manrope', 'sans-serif'],
            },
            colors: {
                background: '#f9fafb',
                foreground: '#0b2040',
                primary:    '#1a6fd4',
                border:     '#d1dce5',
                card:       '#ffffff',
                muted:      '#64748b',
            },
            boxShadow: {
                'card':       '0 2px 8px 0 rgba(11,32,64,0.07)',
                'card-hover': '0 8px 24px -4px rgba(11,32,64,0.13)',
            },
        },
    },
}

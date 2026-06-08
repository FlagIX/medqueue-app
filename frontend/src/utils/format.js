export function formatPrice(cents) {
  if (cents == null) return '—'
  return (cents / 100).toFixed(2)
}

export function formatDate(datetime) {
  if (!datetime) return '—'
  return datetime.substring(0, 10)
}

export function formatScore(score) {
  if (score == null) return '暂无'
  return (score / 10).toFixed(1)
}

const hospGradients = [
  'linear-gradient(135deg, #2d8cf0, #19be6b)',
  'linear-gradient(135deg, #667eea, #764ba2)',
  'linear-gradient(135deg, #4facfe, #00f2fe)',
  'linear-gradient(135deg, #43e97b, #38f9d7)',
  'linear-gradient(135deg, #fa709a, #fee140)',
  'linear-gradient(135deg, #f093fb, #f5576c)',
]

export function getHospitalGradient(id) {
  return hospGradients[Number(id) % hospGradients.length]
}

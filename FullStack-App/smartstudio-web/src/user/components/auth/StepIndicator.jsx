export default function StepIndicator({ current }) {
  const steps = ["Email", "Verifikasi", "Reset"];

  return (
    <div className="sf-steps">
      {steps.map((label, i) => {
        const isDone   = i + 1 < current;
        const isActive = i + 1 === current;

        return (
          <div
            key={i}
            className={`sf-step-group ${isDone ? "done" : ""}`}
          >
            <div
              className={`sf-step ${isActive ? "active" : ""} ${isDone ? "done" : ""}`}
            >
              {isDone ? (
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none">
                  <path
                    d="M20 6L9 17l-5-5"
                    stroke="white"
                    strokeWidth="3"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
              ) : (
                <span>{i + 1}</span>
              )}
            </div>
            <p className={isActive || isDone ? "active" : ""}>{label}</p>
          </div>
        );
      })}
    </div>
  );
}
use baml_runtime::tracingv2::storage::storage::Collector as BamlCollector;
use rustler::{Encoder, Env, Resource, ResourceArc, Term};
use std::sync::Arc;

#[rustler::resource_impl()]
impl Resource for CollectorResource {}

pub struct CollectorResource {
    pub inner: Arc<BamlCollector>,
}

impl CollectorResource {
    pub fn new(name: Option<String>) -> ResourceArc<CollectorResource> {
        let collector = BamlCollector::new(name);
        ResourceArc::new(CollectorResource {
            inner: Arc::new(collector),
        })
    }

    pub fn usage(&self) -> Usage {
        Usage {
            inner: self.inner.clone().usage(),
        }
    }
}

pub struct Usage {
    pub inner: baml_runtime::tracingv2::storage::storage::Usage,
}

impl Encoder for Usage {
    fn encode<'a>(&self, env: Env<'a>) -> Term<'a> {
        let map = Term::map_new(env);
        map.map_put("input_tokens", self.inner.input_tokens)
            .unwrap()
            .map_put("output_tokens", self.inner.output_tokens)
            .unwrap()
    }
}
